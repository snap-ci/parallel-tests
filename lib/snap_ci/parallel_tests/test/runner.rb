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

        def report_test_partitioning?
          true
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

      end #Runner

    end #Test
  end #ParallelTests
end #SnapCI