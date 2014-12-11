require 'snap_ci/parallel_tests/version'
require 'snap_ci/parallel_tests/grouper'
require 'snap_ci/parallel_tests/railtie' if defined?(Rails::Railtie)

module SnapCI
  module ParallelTests
    WINDOWS = (RbConfig::CONFIG['host_os'] =~ /cygwin|mswin|mingw|bccwin|wince|emx/)

    # Partitions the a bunch of things to be run on multiple workers, it partitions based on the following options
    #
    # ==== Options
    #   +things+ - the things to partition
    #   +total_workers+ - the total number of workers, defaults to ParallelTests.total_workers.
    #   +current_worker_index+ - the current worker index (1 based, NOT 0 based), defaults to ParallelTests.worker_index.
    #   +group_by+ - either :filename or :filesize (defaults to :filename). Determines how files are sorted before being distributed into partitions/
    #   +distribution+ - either :round_robin or :chunk (defaults to :roundrobin). Determines how files are distributed across workers, after they are sorted.
    def partition(options={})
      things = options[:things]
      total_workers = options[:total_workers] || ParallelTests.total_workers
      current_worker_index = options[:current_worker_index] || ParallelTests.worker_index
      group_by = options[:group_by] || :filename
      distribution = options[:distribution] || :round_robin

      return [] if things.nil? || things.empty?
      things = Grouper.send("group_by_#{group_by}", things)

      things = Grouper.send("distribute_by_#{distribution}", things, total_workers, current_worker_index)

      things
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
