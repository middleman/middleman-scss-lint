require 'middleman-core'
require_relative 'middleman-scss-lint/version'

::Middleman::Extensions.register(:scss_lint) do
  require_relative 'middleman-scss-lint/extension'
  ::Middleman::ScssLint::Extension
end