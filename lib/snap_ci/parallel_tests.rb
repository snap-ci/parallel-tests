require 'snap_ci/parallel_tests/version'
require 'snap_ci/parallel_tests/railtie' if defined?(Rails::Railtie)

module SnapCI
  module ParallelTests
    WINDOWS = (RbConfig::CONFIG['host_os'] =~ /cygwin|mswin|mingw|bccwin|wince|emx/)

    # index is 1 based, not 0 based
    def partition(things, total_workers, current_worker_index)
      return nil if things.nil? || things.empty?

      thing_count = things.count
      specs_per_worker = (thing_count.to_f/total_workers).ceil

      things.each_slice(specs_per_worker).to_a[current_worker_index-1]
    end

    def total_workers
      if ENV['SNAP_WORKER_TOTAL']
        ENV['SNAP_WORKER_TOTAL'].to_i
      else
        1
      end
    end

    def worker_index
      if ENV['SNAP_WORKER_INDEX']
        ENV['SNAP_WORKER_INDEX'].to_i
      else
        1
      end
    end

    def bundler_enabled?
      return true if Object.const_defined?(:Bundler)

      previous = nil
      current = File.expand_path(Dir.pwd)

      until !File.directory?(current) || current == previous
        filename = File.join(current, 'Gemfile')
        return true if File.exists?(filename)
        current, previous = File.expand_path('..', current), current
      end

      false
    end

    extend SnapCI::ParallelTests
  end
end
