$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'migrator'

require 'mocha'
#require 'output_catcher'

require 'test/unit/assertions'

World(Test::Unit::Assertions)