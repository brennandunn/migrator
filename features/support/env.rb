$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'migrator'

require 'mocha'
require 'output_catcher'

require 'test/unit/assertions'

MIGRATOR_ROOT = File.expand_path File.join(File.dirname(__FILE__), '..', '..')

World(Test::Unit::Assertions)