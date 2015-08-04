PROJECT_ROOT_PATH = File.dirname(File.dirname(File.dirname(__FILE__)))
ENV['TEST'] = 'true'
ENV['CONTRACTS'] = 'true'

# require 'middleman'
require 'middleman-core/step_definitions'
require File.join(PROJECT_ROOT_PATH, 'lib', 'middleman-scss-lint')
