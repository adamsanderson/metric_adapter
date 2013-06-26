Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'metric_adapter'
  s.version     = '0.0.2'
  s.summary     = 'Common interface for multiple static analyzers metrics.'
  s.description = 'Provides a common interface for using metrics generated by tools such as Flog, Flay, and Reek.'

  s.license = 'MIT'

  s.author   = 'Adam Sanderson'
  s.email    = 'netghost@gmail.com'
  s.homepage = 'https://github.com/adamsanderson/metric_adapter'

  s.files        = Dir.glob('{bin,lib,examples,test}/**/*') + ["README.markdown"]
  s.require_path = 'lib'

  s.extra_rdoc_files = %w(README.markdown)
  s.rdoc_options.concat ['--main',  'README.markdown']
end