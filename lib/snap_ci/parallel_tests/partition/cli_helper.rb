module SnapCI
  module ParallelTests
    module Partition
      module CLIHelper
        def render_header(optparser, options)
          optparser.banner = <<BANNER
Partition a list of files/directories and print them

Usage: #{optparser.program_name} [options] [files or directories]

Example: #{optparser.program_name} test/models test/controllers/foo_controller_test.rb

Can typically be used as -

  $ your-test-runner $(snap-ci-parallel-partition location/of/test/files)

BANNER
        end

        def render_options(optparser, options)
          optparser.on('-p', '--pattern [PATTERN]', 'only find files matching this pattern') do |pattern|
            options[:pattern] = /#{pattern}/
          end
        end

        def render_footer(optparser, options)
          optparser.separator ''
        end

        extend CLIHelper
      end #CLIHelper

    end #RSpec
  end #ParallelTests
end #SnapCI
