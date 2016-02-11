# coding: utf-8
require File.expand_path("../lib/timestamp_api/version", __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "timestamp_api"
  spec.version       = TimestampAPI::VERSION
  spec.authors       = ["Michael Baudino"]
  spec.email         = ["michael.baudino@alpine-lab.com"]

  spec.summary       = %q{Unofficial Ruby bindings to interact with Timestamp API}
  spec.description   = %q{Timestamp is "real-time project tracking for you and your clients" according to their website: https://www.timestamphq.com}
  spec.homepage      = "https://github.com/alpinelab/timestamp_api"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z lib`.split("\x0")
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rest-client", "~> 1.7", ">= 1.7.3"
  spec.add_runtime_dependency "colorize", "~> 0.7", ">= 0.7.7"
  spec.add_runtime_dependency "hooks", "~> 0.4", ">= 0.4.1"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.4", ">= 3.4.2"
  spec.add_development_dependency "pry", "~> 0.10", ">= 0.10.3"
  spec.add_development_dependency "awesome_print", "~> 1.6", ">= 0.6.1"
  spec.add_development_dependency "webmock", "~> 1.22"
end
