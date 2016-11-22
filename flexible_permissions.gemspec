# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'flexible_permissions/version'

Gem::Specification.new do |spec|
  spec.name          = "flexible_permissions"
  spec.version       = FlexiblePermissions::VERSION
  spec.authors       = ["Filippos Vasilakis"]
  spec.email         = ["vasilakisfil@gmail.com"]

  spec.summary       = %q{Removes black and white pundit policy and adds flexible permissions for attributes/associations per role class. Perfect for modern APIs.}
  spec.description   = %q{Removes black and white pundit policy and adds flexible permissions for attributes/associations per role class. Perfect for modern APIs.}
  spec.homepage      = "https://github.com/vasilakisfil/flexible-permissions"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
end
