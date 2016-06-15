# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'carrierwave/qcloud/version'

Gem::Specification.new do |spec|
  spec.name          = "carrierwave-qcloud"
  spec.version       = Carrierwave::Qcloud::VERSION
  spec.authors       = ["RainChen"]
  spec.email         = ["hirainchen@gmail.com"]

  spec.summary       = %q{Qcloud COS Storage support for CarrierWave}
  spec.description   = %q{Qcloud COS Storage support for CarrierWave}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency "carrierwave", ">= 0.10.0"
  spec.add_dependency "qcloud_cos", ">= 0.4.2"
end
