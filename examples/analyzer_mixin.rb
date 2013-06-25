require 'flay'
require 'flog'
require 'reek'

# In your actual application, you would configure each of these static
# analyzers to match your own exacting standards.  These mostly use the 
# defaults for each library.
# 
module AnalyzerMixin
  # Generate metrics for Flay.
  # 
  # In this sample, we are setting the `mass` option low so that there are more
  # results.
  # 
  def flay(files, mass = 4)
    flay = Flay.new :mass => mass 
    flay.process(*files)
    flay.analyze
    MetricAdapter::FlayAdapter.new(flay).metrics
  end

  # Generate flog metrics.
  def flog(files)
    flog = Flog.new
    flog.flog(*files)
    MetricAdapter::FlogAdapter.new(flog).metrics
  end

  # Generate Reek metrics.
  def reek(files)
    examiner = Reek::Examiner.new(files)
    MetricAdapter::ReekAdapter.new(examiner).metrics
  end
end