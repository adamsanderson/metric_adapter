module MetricAdapter
  class Metric
    attr_accessor :location
    attr_accessor :signature
    attr_accessor :message
    
    attr_accessor :score

    def initialize(location, signature,  message)
      @location  = location
      @signature = signature
      @message   = message
      @score     = 0
    end
  
  end
end