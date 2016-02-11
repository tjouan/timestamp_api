# coding: utf-8
require File.expand_path('../lib/timestamp_api/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "timestamp_api"
  spec.version       = TimestampAPI::VERSION
  spec.authors       = ["Michael Baudino"]
  spec.email         = ["michael.baudino@alpine-lab.com"]

  spec.summary       = %q{Unofficial Ruby bindings to interact with Timestamp API}
  spec.description   = %q{Timestamp is "real-time project tracking for you and your clients" according to their website: https://www.timestamphq.com}
  spec.homepage      = "https://github.com/alpinelab/timestamp_api"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rest-client", ">= 1.7.3"
  spec.add_runtime_dependency "colorize"
  spec.add_runtime_dependency "hooks"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "awesome_print"
  spec.add_development_dependency "webmock", "~> 1.22"
end
