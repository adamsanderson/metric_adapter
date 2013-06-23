module MetricAdapter
  class FlogAdapter
    attr_reader :flog
  
    def initialize(flog)
      @flog = flog
    end
  
    def metrics
      metrics = []
      
      flog.each_by_score do |signature, score|
        if locatable?(signature)
          metrics << create_metric(signature, score)
        end
      end
      
      metrics
    end
  
    private
  
    def create_metric(signature, score)
      location = method_location(signature)
      message  = "Flog: #{score.round(2)}"
    
      metric = Metric.new(location, signature, message)
      metric.score = score
    
      metric
    end
  
    def method_location(signature)
      path = flog.method_locations[signature]
      Location.new(path)
    end
    
    # Flog will report on code that is not in a class or method,
    # all of this top level code may be spread out across multiple
    # files, so we can're report on that code's location.
    def locatable?(signature)
      !!flog.method_locations[signature]
    end
    
  end
  
end