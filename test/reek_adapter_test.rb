require "minitest/autorun"
require "metric_adapter"

require "reek"

class ReekAdapterTest < MiniTest::Unit::TestCase
  SAMPLE_PATH = 'dirty.rb'
  
  include MetricAdapter
  
  def test_empty_examiner
    examiner = Reek::Examiner.new([])
    adapter  = ReekAdapter.new(examiner)
    
    assert_equal [], adapter.metrics
  end
   
  def test_examiner_adapts_locations
    adapter  = examine_sample
    metric   = adapter.metrics.first
    location = metric.location
    
    assert_equal SAMPLE_PATH, location.path, "Should have included the path"
    assert location.line > 0, "Should have a non zero line number"
  end
  
  def test_examiner_returns_metrics_for_each_line_of_each_smell
    adapter     = examine_sample
    metrics     = adapter.metrics
    total_lines = adapter.examiner.smells.inject(0){|sum, s| sum + s.lines.length}
    
    assert_equal total_lines, metrics.length, "Should have included a metric per line, per smell"
  end

  private
  
  def examine_sample
    examiner = Reek::Examiner.new(sample)
    ReekAdapter.new(examiner)
  end
  
  def sample
    Reek::Source::SourceCode.new(<<-SAMPLE, SAMPLE_PATH)
      # Reek Sample Code
      class Dirty
        def a
          puts @s.title
          @s = fred.map {|x| x.each {|key| key += 3}}
          puts @s.title
        end
      end
    SAMPLE
  end
  
end