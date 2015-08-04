module Middleman
  module ScssLint
    class Extension < ::Middleman::Extension
      option :config, nil, 'Path to config file'
      option :fail_build, false, 'If the build should fail if lint does not pass.'

      def after_configuration
        require 'scss_lint'
        require 'scss_lint/cli'

        if app.build?
          result = run_once

          if options[:fail_build] && result != ::SCSSLint::CLI::EXIT_CODES[:ok]
            $stderr.puts "== Scss Lint failed"
            exit(1)
          end
        else
          watch_and_run
        end
      end

      def run_once
        paths = app.sitemap.resources
            .select { |r| r.ext == '.scss' }
            .map { |r| r.source_file[:full_path].to_s }

        run_linter(paths)
      end

      def watch_and_run
        app.files.on_change :source do |changed|
          changed_scss = changed.select do |f|
            f[:full_path].extname == '.scss'
          end

          if changed_scss.length > 0
            run_linter(changed_scss.map { |r| r[:full_path].to_s })
          end
        end
      end

      def run_linter(files_to_lint)
        puts "== Linting Scss"

        cli_args = ['--config', options[:config]] if options[:config]

        ::SCSSLint::CLI.new.run(Array(cli_args) + files_to_lint)
      end
    end
  end
end
