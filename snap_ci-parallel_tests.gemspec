# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'snap_ci/parallel_tests/version'

Gem::Specification.new do |spec|
  spec.name          = "snap_ci-parallel_tests"
  spec.version       = SnapCI::ParallelTests::VERSION
  spec.authors       = ["Ketan Padegaonkar"]
  spec.email         = ["KetanPadegaonkar@gmail.com"]
  spec.summary       = %q{Run Test::Unit / RSpec in parallel across multiple workers on Snap CI}
  spec.description   = %q{Run Test::Unit / RSpec in parallel across multiple workers on Snap CI}
  spec.homepage      = "https://github.com/snap-ci/parallel-tests"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
