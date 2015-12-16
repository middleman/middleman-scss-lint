# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'middleman-scss-lint/version'

Gem::Specification.new do |spec|
  spec.name          = 'middleman-scss-lint'
  spec.version       = Middleman::ScssLint::VERSION
  spec.authors       = ['Thomas Reynolds']
  spec.email         = ['me@tdreyno.com']
  spec.summary       = 'ScssLint integration with Middleman'
  spec.homepage      = 'https://github.com/middleman/middleman-scss-lint'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = `git ls-files -- {features,fixtures}/*`.split($/)
  spec.require_paths = ['lib']

  spec.add_dependency 'middleman-core', '>= 4.0.0'
  spec.add_dependency 'scss_lint', '~> 0.40'
  spec.add_dependency 'rainbow'
end
