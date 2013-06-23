DIR_NAME = File.dirname(__FILE__)
$:.unshift(DIR_NAME + '/../lib')

require 'metric_adapter'

require 'flay'
require 'flog'
require 'reek'

#
# This is a quick and dirty example of using MetricAdapter to provide a common
# interface for Flay, Flog, and Reek's metrics.
#

files = Dir[DIR_NAME + '/../lib/**/*.rb']

# Generate metrics for Flay.
# 
# In this sample, we are setting the `mass` option low so that there are more
# results.
# 
def flay(files)
  flay = Flay.new :mass => 4 
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

# Helper for displaying an ascii divider
def divider(char="-")
  char * 80
end

# Combine metrics from all our sources:
metrics = flay(files) + flog(files) + reek(files)

# Group those metrics by path
metrics_by_path = metrics.group_by{|m| m.location.path }

# For each path, print out a little report.
metrics_by_path.each do |path, metrics|
  puts divider
  puts path
  puts divider
  puts "  line: message"
  metrics.sort_by{|m| m.location }.each do |m|
    puts "%6d: %s" % [m.location.line, m.message]
  end
end