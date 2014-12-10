require 'shellwords'
require 'snap_ci/parallel_tests/rspec/cli_helper'

module SnapCI
  module ParallelTests
    module RSpec
      class Runner

        def execute(test_files, options)
          exe = determine_executable
          version = (exe =~ /\brspec\b/ ? 2 : 1)

          test_files = test_files.map { |f| Shellwords.escape(f) }

          cmd = [exe, options[:test_opts], (rspec_2_color if version == 2), *test_files].compact.join(' ')
          options = options.merge(:env => rspec_1_color) #if version == 1

          $stderr.puts(cmd)
          exec((options[:env] || {}), cmd)
        end

        def cli_helper
          CLIHelper
        end

        def test_suffix
          /_spec\.rb$/
        end

        def test_file_name
          'spec'
        end

        private

        def determine_executable
          cmd = case
            when File.exists?('bin/rspec')
              WINDOWS ? 'ruby bin/rspec' : 'bin/rspec'
            when File.file?('script/spec')
              'script/spec'
            when SnapCI::ParallelTests.bundler_enabled?
              cmd = (output_of('bundle show rspec-core') =~ %r{Could not find gem.*} ? 'spec' : 'rspec')
              "bundle exec #{cmd}"
            else
              %w[spec rspec].detect { |cmd| system "#{cmd} --version > #{DEV_NULL} 2>&1" }
          end

          cmd or raise("Can't find executables rspec or spec")
        end

        def output_of(cmd)
          `#{cmd}`
        end

        def rspec_2_color
          '--color --tty' if $stdout.tty?
        end

        def rspec_1_color
          if $stdout.tty?
            { 'RSPEC_COLOR' => '1' }
          else
            {}
          end
        end

      end #Runner

    end #RSpec
  end #ParallelTests
end #SnapCI