require 'metric'
require 'location'

module MetricAdapter
  autoload :FlogAdapter, 'adapters/flog_adapter'
  autoload :FlayAdapter, 'adapters/flay_adapter'
  autoload :ReekAdapter, 'adapters/reek_adapter'
end