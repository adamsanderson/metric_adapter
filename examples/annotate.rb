DIR_NAME = File.dirname(__FILE__)
$:.unshift(DIR_NAME + '/../lib')

require "metric_adapter"
require "./#{DIR_NAME}/analyzer_mixin"

include AnalyzerMixin

files = ARGV

def report_on_file(path, metrics)
  return if metrics.empty?
  
  metrics_by_line = metrics.group_by{|m| m.location.line }
  
  source = IO.read(path)
  source.lines.each_with_index do |src_line, i|
    line_number = i + 1 # Logical line numbers, not indices
    src_line    = src_line.chomp # Strip newline
    indent      = src_line.scan(/\A\s+/).first
    
    if metrics_by_line[line_number]
      metrics_by_line[line_number].each do |m|
        puts "\033[90m%5d. \033[38;5;109m#{indent}%s\033[0m" % [line_number, m.message]
      end
    end
    
    if src_line =~ /^\s*#/
      puts "\033[90m%5d. \033[90m%s\033[0m" % [line_number, src_line]
    else
      puts "\033[90m%5d. \033[39m%s\033[0m" % [line_number, src_line]
    end

  end
end

# Combine metrics from all our sources (See AnalyzerMixin):
metrics = flay(files, 16) + flog(files) + reek(files)

metrics_by_path = Hash.new{|h,k| h[k] = [] }
metrics.each do |m|
  path = m.location.path
  metrics_by_path[path] << m
end

files.each do |path|
  metrics = metrics_by_path[path]
  report_on_file(path, metrics)
end