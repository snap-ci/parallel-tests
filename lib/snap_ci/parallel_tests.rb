require 'snap_ci/parallel_tests/version'
require 'snap_ci/parallel_tests/railtie' if defined?(Rails::Railtie)

module SnapCI
  module ParallelTests
    def partition(things, total_workers, current_worker_index)

      thing_count = things.count
      specs_per_worker = (thing_count.to_f/total_workers).ceil

      things.each_slice(specs_per_worker).to_a[current_worker_index]
    end

    module_function :partition
  end
end
