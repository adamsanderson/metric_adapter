module MetricAdapter
  class ReekAdapter
    attr_reader :examiner
  
    def initialize(examiner)
      @examiner = examiner
    end
  
    def metrics
      metrics = examiner.smells.map do |smell|
        line_numbers = Array(smell.lines).uniq
        line_numbers.map do |line|
          create_metric(smell, line)
        end
      end
      
      metrics.flatten
    end
  
    private
  
    def create_metric(smell, line)
      location  = Location.new(smell.source, line)
      message   = "#{smell.message.capitalize} (#{smell.subclass})"
      signature = smell.context

      Metric.new(location, signature, message)
    end

  end
  
end