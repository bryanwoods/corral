# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'corral/version'

Gem::Specification.new do |spec|
  spec.name          = "corral"
  spec.version       = Corral::VERSION
  spec.authors       = ["Bryan Woods"]
  spec.email         = ["bryanwoods4e@gmail.com"]
  spec.summary       = "Use Corral to disable certain features in your application."
  spec.homepage      = "http://github.com/bryanwoods/corral"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "pry", "~> 0.10.4"
end
