module SnapCI
  module ParallelTests
    class Railtie < Rails::Railtie
      rake_tasks do
        load 'snap_ci/parallel_tests/tasks/parallel_specs.rake'
      end
    end
  end
end
