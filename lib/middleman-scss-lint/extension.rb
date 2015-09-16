module Middleman
  module ScssLint
    class Extension < ::Middleman::Extension
      option :config, nil, 'Path to config file'
      option :fail_build, false, 'If the build should fail if lint does not pass.'

      def ready
        require 'rainbow'
        require 'rainbow/ext/string'

        result = run_once

        if app.build?
          if options[:fail_build] && !result
            logger.error "== SCSSLint failed"
            exit(1)
          end
        else
          logger.info "== SCSSLint succeeded" if result
          watch_and_run
        end
      end

      def run_once
        paths = app.sitemap.resources
            .select { |r| r.source_file.extname == '.scss' }
            .map { |r| r.source_file.to_s }

        run_linter(paths)
      end

      def watch_and_run
        app.files.on_change :source do |changed|
          changed_scss = changed.select do |f|
            f[:full_path].extname == '.scss'
          end

          if changed_scss.length > 0
            result = run_linter(changed_scss.map { |r| r[:full_path].to_s })
            logger.info "== SCSSLint succeeded" if result
          end
        end
      end

      def run_linter(files_to_lint)
        logger.info "== Linting SCSS"

        cli_args = ['--format', 'JSON']
        cli_args = cli_args + ['--config', options[:config]] if options[:config]
        cli_args = cli_args + files_to_lint

        begin
          output = ""

          ::IO.popen("bundle exec scss-lint #{cli_args.join(' ')}", 'r') do |pipe|
            while buf = pipe.gets
              output << buf
            end
          end

          error_count = 0

          result = ::JSON.parse(output)

          result.each do |file_path, lints|
            relative_path = file_path.sub(app.root, '')

            lints.each do |descr|
              msg = "#{location(relative_path, descr)} #{type(descr)} #{message(descr)}"

              error_count += 1

              if descr["severity"] == "warning"
                logger.warn msg
              else
                logger.error msg
              end 
            end
          end

          error_count <= 0
        rescue ::Errno::ENOENT => e
          logger.error "== SCSSLint: Command failed with message: #{e.message}"
          exit(1)
        end
      end

      def location(path, descr)
        "#{path.color(:cyan)}:#{descr["line"].to_s.color(:magenta)}"
      end

      def type(descr)
        descr["severity"] == "error" ? '[E]'.color(:red) : '[W]'.color(:yellow)
      end

      def message(descr)
        linter_name = "#{descr["linter"]}: ".color(:green)
        "#{linter_name}#{descr["reason"]}"
      end
    end
  end
end
