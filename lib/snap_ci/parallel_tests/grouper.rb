module SnapCI
  module ParallelTests
    class Grouper
      class <<self
        def group_by_filename(things)
          things.sort
        end

        def group_by_filesize(things)
          things.sort { |a, b| File.size(a) <=> File.size(b) }
        end

        def distribute_by_round_robin(things, total_workers, current_worker_index)
          result = []

          # pick up things on a round-robin basis to distribute them evenly
          index = current_worker_index - 1
          while index <= things.count do
            result << things[index]
            index += total_workers
          end
          result.compact!

          result
        end

        def distribute_by_chunk(things, total_workers, current_worker_index)
          thing_count = things.count
          specs_per_worker = (thing_count.to_f/total_workers).ceil

          things.each_slice(specs_per_worker).to_a[current_worker_index-1] || []
        end
      end
    end
  end
end