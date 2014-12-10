module SnapCI
  module ParallelTests
    module RSpec
      module CLIHelper
        def render_header(opts)
          opts.banner = <<BANNER
Usage: #{opts.program_name} [options] [files or directories] [-- [rspec options]]

Example: #{opts.program_name} spec/models spec/controllers/foo_controller_spec.rb -- --format documentation --fail-fast
BANNER
        end

        def render_options(opts)
          opts.on('-p', '--pattern [PATTERN]', 'run tests matching this pattern') do |pattern|
            options[:pattern] = /#{pattern}/
          end
        end

        def render_footer(opts)
          opts.separator "\nRun `rspec --help' for supported rspec options."
        end

        extend CLIHelper
      end #CLIHelper

    end #RSpec
  end #ParallelTests
end #SnapCI