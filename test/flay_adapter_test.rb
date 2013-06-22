require "minitest/autorun"
require "metric_adapter"

require "flay"

class FlayAdapterTest < MiniTest::Unit::TestCase
  include MetricAdapter
  
  def test_empty_flay
    flay    = Flay.new
    adapter = FlayAdapter.new(flay)
    
    assert_equal [], adapter.metrics
  end
  
  def test_flay_adapts_locations
    adapter  = flay_self
    flay = adapter.flay
    # For each set of similar nodes, it should generate all the permutations (nodes choose 2)
    expected_count = flay.hashes.map{|h, nodes| nodes ** 2}.inject{|n,m| n+m }
    
    assert_equal expected_count, adapter.metrics.length, "Each set of similar nodes should generate n^2 metrics"
  end
  
  def test_flay_adapts_locations
    adapter  = flay_self
    metric   = adapter.metrics.first
    location = metric.location
    
    assert_equal __FILE__, location.path, "Should reference this file"
    assert location.line != 0, "Line numbers should be captured (line:0 should not show up in flog)"
  end
  
  def test_flay_messages
    adapter  = flay_self
    metric   = adapter.metrics.first
    message  = metric.message
    
    assert message =~ /flay/i,   "Should reference flay: #{message.inspect}"
    assert message =~ /#{Regexp.escape __FILE__}:\d+/, "Should reference the a path: #{message.inspect}"
  end
  
  private
  
  def flay_self
    flay = Flay.new :mass => 2
    flay.process(__FILE__)
    flay.analyze
    
    FlayAdapter.new(flay)
  end
  
end