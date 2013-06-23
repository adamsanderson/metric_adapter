module MetricAdapter
  class ReekAdapter
    attr_reader :examiner
  
    def initialize(examiner)
      @examiner = examiner
    end
  
    def metrics
      metrics = examiner.smells.map do |smell|
        smell.lines.map do |line|
          create_metric(smell, line)
        end
      end
      
      metrics.flatten
    end
  
    private
  
    def create_metric(smell, line)
      location  = Location.new(smell.source, line)
      message   = "#{smell.message} (#{s.subclass})".capitalize
      signature = smell.context

      Metric.new(location, signature, message)
    end

  end
  
end