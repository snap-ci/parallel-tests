require 'shellwords'
require 'snap_ci/parallel_tests/test/cli_helper'

module SnapCI
  module ParallelTests
    module Test
      class Runner

        def execute(test_files, options)
          test_files = test_files.map { |f| Shellwords.escape(f) }

          cmd = ['ruby', '-Itest', test_files, options[:test_opts]].flatten.compact.join(' ')

          $stderr.puts(cmd)

          exec(cmd)
        end

        def cli_helper
          CLIHelper
        end

        def test_suffix
          /_(test|spec).rb$/
        end

        def test_file_name
          'test'
        end

        private

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