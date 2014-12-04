#try and see what frameworks are available

%w(
  rspec-rails
  rspec/core
  rspec/core/rake_task
).each do |library|
  begin
    require library
  rescue LoadError
    puts "could not require #{library}"
  end
end

if defined?(RSpec) && ENV['SNAP_CI'] && ENV['SNAP_WORKER_TOTAL'] && ENV['SNAP_WORKER_INDEX']
  num_workers = ENV['SNAP_WORKER_TOTAL'].to_i
  worker_index = ENV['SNAP_WORKER_INDEX'].to_i - 1

  desc "Run all specs in spec directory (excluding plugin specs)"
  RSpec::Core::RakeTask.new(:'snap-parallel' => "snap-parallel:prepare") do |t|
    all_specs = FileList["./spec/**{,/*/**}/*_spec.rb"].sort
    specs_to_run = SnapCI::ParallelTests.partition(all_specs, num_workers, worker_index)

    if specs_to_run && specs_to_run.count > 0
      t.pattern = specs_to_run
    end
  end

  namespace :'snap-parallel' do
    types = begin
      dirs = Dir['./spec/**/*_spec.rb'].
        map { |f| f.sub(/^\.\/(spec\/\w+)\/.*/, '\\1') }.
        uniq.
        select { |f| File.directory?(f) }
      Hash[dirs.map { |d| [d.split('/').last, d] }]
    end

    task :prepare do
      ENV['RACK_ENV'] = ENV['RAILS_ENV'] = 'test'
      if Rails.configuration.generators.options[:rails][:orm] == :active_record
        if Rake::Task.task_defined?("test:prepare")
          Rake::Task["test:prepare"].invoke
        end
      end
    end

    types.each do |type, dir|
      desc "Run the code examples in #{dir}"
      all_specs = FileList["./#{dir}/**/*_spec.rb"].sort
      specs_to_run = SnapCI::ParallelTests.partition(all_specs, num_workers, worker_index)

      RSpec::Core::RakeTask.new(type => "snap-parallel:prepare") do |t|
        t.pattern = specs_to_run
      end
    end
  end
end
