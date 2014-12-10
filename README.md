# SnapCI::ParallelTests [![Build Status](https://snap-ci.com/snap-ci/parallel-tests/branch/master/build_image)](https://snap-ci.com/snap-ci/parallel-tests/branch/master)

Run Test::Unit / RSpec in parallel across multiple workers on [Snap CI](https://snap-ci.com).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'snap_ci-parallel_tests'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install snap_ci-parallel_tests

## Setup for non-rails

Depending on the framework of your choice -

    $ bundle exec snap-ci-parallel-rspec [options] [files or directories] [-- [rspec options]]
    $ bundle exec snap-ci-parallel-test [options] [files or directories] [-- [Test::Unit or MiniTest options]]


## Setup for Rails

Ensure that 'snap_ci-parallel_tests' is present in your development group

```ruby
# Gemfile
gem "snap_ci-parallel_tests", :group => :development
```

### Run

    $ bundle exec snap-ci-parallel-rspec [options] [files or directories] [-- [rspec options]]
    $ bundle exec snap-ci-parallel-test [options] [files or directories] [-- [Test::Unit or MiniTest options]]

Alternatively -

```shell
$ bundle exec rake snap-parallel             # to run all specs
$ bundle exec rake snap-parallel:models      # to run only model specs
$ bundle exec rake snap-parallel:controllers # to run only controllers specs
$ bundle exec rake -T snap-parallel          # to list all tasks
```



## Contributing

1. Fork it ( https://github.com/[my-github-username]/parallel-tests/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
