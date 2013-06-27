module MetricAdapter
  class FlayAdapter
    attr_reader :flay
  
    def initialize(flay)
      @flay = flay
    end
  
    def metrics
      metrics = flay.hashes.map do |hash_key, nodes|
        nodes.permutation(2).map do |node_a, node_b|
          create_metric(hash_key, node_a, node_b)
        end
      end

      metrics.flatten
    end
  
    private
      
    def create_metric(hash_key, node_a, node_b)
      is_identical = flay.identical[hash_key]
      similarity   = is_identical ? "identical" : "similar"
      score = flay.masses[hash_key]
      
      message = "Flay: #{score}, #{similarity} to #{node_location(node_b)}"
      # TODO: generate signatures from locations
      signature = ""
      
      metric = Metric.new(node_location(node_a), signature, message)
      metric.score = score
      metric
    end
    
    def node_location(node)
      Location.new(node.file, node.line)
    end
  end
  
end