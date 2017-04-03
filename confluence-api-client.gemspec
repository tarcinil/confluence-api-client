# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'confluence/api/client/version'

Gem::Specification.new do |spec|
  spec.name          = "confluence-api-client"
  spec.version       = Confluence::Api::Client::VERSION
  spec.authors       = ["Serdar Gokay Kucuk"]
  spec.email         = ["serdargokaykucuk@gmail.com"]
  spec.homepage      = "https://github.com/gkaykck/confluence-api-client"


  spec.summary       = %q{Rest client to confluence JSON api}
  spec.description   = %q{Rest client to confluence api with ability to upload files and edit pages.}
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_runtime_dependency "json", "~> 2"
  spec.add_runtime_dependency "faraday", "~> 0.12"
  spec.add_runtime_dependency "mimemagic", "~> 0.3"
end
