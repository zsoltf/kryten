# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kryten/version'

Gem::Specification.new do |spec|
  spec.name          = "kryten"
  spec.version       = Kryten::VERSION
  spec.authors       = ["Zsolt Fekete"]
  spec.email         = ["zsoltf@me.com"]
  spec.homepage      = "https://github.com/zsoltf/kryten"

  spec.summary       = %q{Modular Task Runner}
  spec.description   = %q{Modular task runner and job manager. Supports daemons and threads.}
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "pry"

  spec.add_dependency "daemons", "~> 1.2.0"
  spec.add_dependency "logger"
end
