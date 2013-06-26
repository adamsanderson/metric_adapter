module MetricAdapter
  
  # A normalized representation of a code metric.
  class Metric
    
    # Location where this metric applies (see the Location class)
    attr_accessor :location
    
    # Associated class and method signature
    attr_accessor :signature
    
    # Message indicating the issue being reported
    attr_accessor :message
    
    # Optional score for for the metric indicating severity
    # A score is not normalized across analyzers
    attr_accessor :score
    
    # Create an instance of Metric.
    # `location` is expected to be a `Location` instance
    def initialize(location, signature,  message)
      @location  = location
      @signature = signature
      @message   = message
      @score     = 0
    end
    
    # Returns the path that this metric applies to, for example:
    #   ./lib/metric.rb
    def path
      location.path
    end
    
    # Returns the line number this metric applies to.
    def line
      location.line
    end
    
  end
end