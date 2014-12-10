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
      end
    end
  end
end