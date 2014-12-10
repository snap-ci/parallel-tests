module SnapCI
  module ParallelTests
    module Test
      module CLIHelper
        def render_header(opts)
          opts.banner = <<BANNER
Usage: #{opts.program_name} [options] [files or directories] [-- [Test::Unit or MiniTest options]]

Example: #{opts.program_name} test/models test/controllers/foo_controller_test.rb -- --verbose --seed 10
BANNER
        end

        def render_options(opts)
          opts.on('-p', '--pattern [PATTERN]', 'run tests matching this pattern') do |pattern|
            options[:pattern] = /#{pattern}/
          end
        end

        def render_footer(opts)
          opts.separator "\nRun `ruby -r test/test_helper -e1 --help' for supported Test::Unit or MiniTest options."
        end

        extend CLIHelper
      end #CLIHelper

    end #RSpec
  end #ParallelTests
end #SnapCI