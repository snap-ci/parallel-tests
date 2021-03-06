module SnapCI
  module ParallelTests
    module Test
      module CLIHelper
        def render_header(optparser, options)
          optparser.banner = <<BANNER
Usage: #{optparser.program_name} [options] [files or directories] [-- [Test::Unit or MiniTest options]]

Example: #{optparser.program_name} test/models test/controllers/foo_controller_test.rb -- --verbose --seed 10
BANNER
        end

        def render_options(optparser, options)
          optparser.on('-p', '--pattern [PATTERN]', 'run tests matching this pattern') do |pattern|
            options[:pattern] = /#{pattern}/
          end
        end

        def render_footer(optparser, options)
          optparser.separator "\nRun `ruby -r test/test_helper -e1 --help' for supported Test::Unit or MiniTest options."
        end

        extend CLIHelper
      end #CLIHelper

    end #Test
  end #ParallelTests
end #SnapCI