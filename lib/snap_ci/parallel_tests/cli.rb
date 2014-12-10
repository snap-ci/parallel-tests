require 'optparse'

module SnapCI
  module ParallelTests
    class CLI
      attr_reader :runner, :argv, :test_opts

      def initialize(runner, argv)
        @runner = runner

        @argv = argv.dup
        @test_opts = nil

        if split_index = @argv.index('--')
          @test_opts = @argv.drop(split_index + 1).join(' ')
          @argv = @argv.take(split_index)
        end
      end

      def run
        options = parse!
        test_files = find_all_tests(options[:files_or_dirs], options)

        if options[:trace]
          $stderr.puts "Found the following #{runner.test_file_name}s"
          $stderr.puts test_files.collect { |t| " - #{t}" }.join("\n")
        end

        report_number_of_tests(test_files, SnapCI::ParallelTests.total_workers)

        test_files_to_run = SnapCI::ParallelTests.partition(test_files, SnapCI::ParallelTests.total_workers, SnapCI::ParallelTests.worker_index)

        if test_files_to_run.empty?
          $stderr.puts 'No tests to run'
        else
          if options[:trace]
            $stderr.puts "Will run the following #{runner.test_file_name}s and ignore others"
            $stderr.puts test_files.collect { |t| " - #{t}" }.join("\n")
          end
          runner.execute(test_files_to_run, options)
        end


      end

      private

      def find_all_tests(tests, options = {})
        (tests || []).map do |file_or_folder|
          if File.directory?(file_or_folder)
            files = files_in_folder(file_or_folder, options)
            files.grep(runner.test_suffix).grep(options[:pattern]||//)
          else
            file_or_folder
          end
        end.flatten.uniq.sort
      end

      def files_in_folder(folder, options={})
        pattern = if options[:symlinks] == false # not nil or true
          '**/*'
        else
          # follow one symlink and direct children
          # http://stackoverflow.com/questions/357754/can-i-traverse-symlinked-directories-in-ruby-with-a-glob
          '**{,/*/**}/*'
        end
        Dir[File.join(folder, pattern)].uniq
      end

      def report_number_of_tests(tests, total_workers)
        name = runner.test_file_name
        num_tests = tests.size
        puts "#{total_workers} workers for #{num_tests} #{name}s, ~ #{(num_tests.to_f/total_workers).ceil} #{name}s per process"
      end

      def parse!
        options = {}
        parser = OptionParser.new do |opts|
          runner.cli_helper.render_header(opts)
          opts.separator 'supported options:'

          runner.cli_helper.render_options(opts)

          opts.on('-v', '--version', 'Show Version') do
            puts "SnapCI Parallel Tests v#{SnapCI::ParallelTests::VERSION}"
            exit
          end

          opts.on('-t', '--trace', 'Turn on verbose mode') do |trace|
            options[:trace] = trace
          end

          opts.on('-h', '--help', 'Show this help screen.') do
            puts opts
            exit
          end

          runner.cli_helper.render_footer(opts)
        end

        parser.parse!(argv)

        options[:files_or_dirs] = argv
        options[:test_opts] = test_opts

        if options[:trace]
          $stderr.puts "trace - got options #{options.inspect}"
        end
        options
      end
    end
  end
end
