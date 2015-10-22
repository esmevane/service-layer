# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'service_layer/version'

Gem::Specification.new do |spec|
  spec.name          = "service-layer"
  spec.version       = ServiceLayer.version_string
  spec.authors       = ["Joseph McCormick"]
  spec.email         = ["esmevane@gmail.com"]

  spec.summary       = %q{Boilerplate for client/service gems.}
  spec.description   = %q{Build service layer gems with quick conventions.}
  spec.homepage      = "https://github.com/esmevane/service-layer"
  spec.license       = "N/A"

  spec.bindir        = "bin"
  spec.require_paths = ["lib"]

  spec.files         = `git ls-files -z`.split("\x0").reject do |file|
    file.match(%r{^(test|spec|features)/})
  end

  spec.executables   = spec.files.grep(%r{^bin/}) do |file|
    File.basename(file)
  end

  spec.add_dependency "ansi", "~> 1.5"
  spec.add_dependency "daemons", "~> 1.2"
  spec.add_dependency "faraday", "~> 0.9"
  spec.add_dependency "grape", "~> 0.12"
  spec.add_dependency "grape-entity", "~> 0.4"
  spec.add_dependency "thor", "~> 0.19"

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.3"
  spec.add_development_dependency "rack-test", "~> 0.6"
  spec.add_development_dependency "simplecov", "~> 0.10"

end
