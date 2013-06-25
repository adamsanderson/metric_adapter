DIR_NAME = File.dirname(__FILE__)
$:.unshift(DIR_NAME + '/../lib')

require "metric_adapter"
require "./#{DIR_NAME}/analyzer_mixin"

#
# This is an example of using MetricAdapter to provide a common
# interface for Flay, Flog, and Reek's metrics to annotate a file.
#

include AnalyzerMixin

COLORS = {
  :normal    => "\033[39m",
  :alternate => "\033[38;5;109m",
  :faded     => "\033[90m"
}

files = ARGV.empty? ? [__FILE__] : ARGV

def report_on_file(path, metrics)
  puts "\n#{path}"
  return if metrics.empty?
  
  metrics_by_line = metrics.group_by{|m| m.location.line }
  
  source = IO.read(path)
  source.lines.each_with_index do |src_line, i|
    line_number  = i + 1 # Logical line numbers, not indices
    src_line     = src_line.chomp # Strip newline
    indent       = src_line.scan(/\A\s+/).first
    line_metrics = metrics_by_line[line_number]

    print_metrics(line_number, line_metrics, indent)
    print_src(line_number, src_line)
  end
end

def print_metrics(line_number, metrics, indent = "")
  return unless metrics
  
  metrics.each do |m|
    print_line line_number, "#{indent}#{m.message}", :alternate
  end
end

def print_src(line_number, src_line)
  if src_line =~ /^\s*#/
    # Print a comment
    print_line line_number, src_line, :faded
  else
    # Print a normal line
    print_line line_number, src_line, :normal
  end
end

def print_line(line_number, text, name)
  formatted_number = '%5d.' % line_number
  puts "#{color formatted_number, :faded} #{color text, name}"
end

def color(text, name)
  "#{COLORS[name]}#{text}\033[0m"
end

# Combine metrics from all our sources (See AnalyzerMixin):
metrics = flay(files, 16) + flog(files) + reek(files)

metrics_by_path = metrics.group_by{|m| m.location.path }

files.each do |path|
  metrics = metrics_by_path[path]
  report_on_file(path, metrics)
end