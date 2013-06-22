require "minitest/autorun"
require "metric_adapter"

require "flog"

class FlogAdapterTest < MiniTest::Unit::TestCase
  include MetricAdapter
  
  def test_empty_flog
    flog    = Flog.new
    adapter = FlogAdapter.new(flog)
    
    assert_equal [], adapter.metrics
  end
  
  def test_flogging_adapts_locations
    adapter  = flog_self
    metric   = adapter.metrics.first
    location = metric.location
    
    assert_equal __FILE__, location.path, "Should reference this file"
    assert location.line != 0, "Line numbers should be captured (line:0 should not show up in flog)"
  end
  
  def test_flogging_messages
    adapter  = flog_self
    metric   = adapter.metrics.first
    message  = metric.message
    
    assert message =~ /flog/i, "Should reference flog: #{message.inspect}"
    assert message =~ /\d+/,  "Should reference the score: #{message.inspect}"
  end
  
  private
  def flog_self
    flog = Flog.new
    flog.flog(__FILE__)
    
    FlogAdapter.new(flog)
  end
end