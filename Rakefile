require 'rake'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

task :default => :test

desc "Runs tests and examples to verify everything is working"
task :integration => [:test, :examples]

desc "Runs all the examples"
task :examples => [:annotate_example, :report_example]

desc "Runs the annotate example"
task :annotate_example do
  `ruby examples/annotate.rb`
  raise "Annotate example failed" unless $?.success?
end

desc "Runs the report example"
task :report_example do
  `ruby examples/report.rb`
  raise "Report example failed" unless $?.success?
end