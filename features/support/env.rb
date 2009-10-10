$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'migrator'

require 'rr'
require 'output_catcher'

require 'test/unit/assertions'

MIGRATOR_ROOT = File.expand_path File.join(File.dirname(__FILE__), '..', '..')

World(Test::Unit::Assertions)
World(RR::Adapters::RRMethods)

Before do
  RR.reset
end

After do
  begin
    RR.verify
  ensure
    RR.reset
  end
end