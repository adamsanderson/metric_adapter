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
    
    assert_equal __FILE__, metric.path, "Should reference this file"
    assert metric.line != 0, "Line numbers should be captured (line:0 should not show up in flog)"
  end
  
  def test_flogging_messages
    adapter  = flog_self
    metric   = adapter.metrics.first
    message  = metric.message
    
    assert message =~ /flog/i, "Should reference flog: #{message.inspect}"
    assert message =~ /\d+/,  "Should reference the score: #{message.inspect}"
  end
  
  def test_ignoring_unlocatable_metrics
    flog  = Flog.new
    flog.flog_ruby top_level_sample, "sample.rb"
    flog.calculate_total_scores 
    
    adapter = FlogAdapter.new(flog)
    metrics = adapter.metrics
    
    assert metrics.empty?, "Flog should not attach location information to top level source"
  end
  
  private
  def flog_self
    flog = Flog.new
    flog.flog(__FILE__)
    
    FlogAdapter.new(flog)
  end
  
  def top_level_sample
    <<-RUBY
      # Some good meaningless floggable source outside the scope of a method
      if xs.any?{|x| x ? true : false} && x.length > 3 && x.length < 9
        xs.each do |x|
          (x+1).times{|xp| report(xp / 2)}
          yield x-1
        end
        if xs.length % 2 == 0 
          puts xs.length % 4 == 0 ? 1 : 0
        end
      end
      
      puts xs.join(", ")
    RUBY
  end
end