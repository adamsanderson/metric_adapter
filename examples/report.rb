DIR_NAME = File.dirname(__FILE__)
$:.unshift(DIR_NAME + '/../lib')

require "metric_adapter"
require "./#{DIR_NAME}/analyzer_mixin"

include AnalyzerMixin

#
# This is a quick and dirty example of using MetricAdapter to provide a common
# interface for Flay, Flog, and Reek's metrics.
#

files = ARGV.empty? ? Dir[DIR_NAME + '/../lib/**/*.rb'] : ARGV

# Helper for displaying an ascii divider
def divider(char="-")
  char * 80
end

# Combine metrics from all our sources (See AnalyzerMixin):
metrics = flay(files) + flog(files) + reek(files)

# Group those metrics by path
metrics_by_path = metrics.group_by{|m| m.path }

# For each path, print out a little report.
metrics_by_path.each do |path, metrics|
  puts divider
  puts path
  puts divider
  
  puts "  line: message"
  metrics.sort_by{|m| m.line }.each do |m|
    puts "%6d: %s" % [m.line, m.message]
  end
end