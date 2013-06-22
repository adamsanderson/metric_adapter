module MetricAdapter
  class FlogAdapter
    attr_reader :flog
  
    def initialize(flog)
      @flog = flog
    end
  
    def metrics
      metrics = []
      
      flog.each_by_score do |signature, score|
        metrics << create_metric(signature, score)
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
  end
  
end