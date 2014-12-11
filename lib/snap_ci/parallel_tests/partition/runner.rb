require 'shellwords'
require 'snap_ci/parallel_tests/partition/cli_helper'

module SnapCI
  module ParallelTests
    module Partition
      class Runner

        def execute(test_files, options)
          $stdout.puts(test_files.collect {|f| f.dump }.join(' '))
        end

        def report_test_partitioning?
          false
        end

        def cli_helper
          CLIHelper
        end

        def test_suffix
          //
        end

        def test_file_name
          'file'
        end

      end #Runner

    end #Partition
  end #ParallelTests
end #SnapCI
