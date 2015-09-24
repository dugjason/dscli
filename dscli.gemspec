# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dscli/version'

Gem::Specification.new do |spec|
  spec.name          = "dscli"
  spec.version       = Dscli::VERSION
  spec.authors       = ["Jason Dugdale"]
  spec.email         = ["jason.dugdale@gmail.com"]
  spec.description   = %q{DS CLI is a CLI wrapper for the DataSift Ruby client library, allowing you to make common DataSift API calls via the command line.}
  spec.summary       = %q{Simple CLI wrapper for the DataSift Ruby client library}
  spec.homepage      = "https://github.com/dugjason/dscli"
  spec.license       = "BSD"

  spec.files         = Dir.glob("{bin,lib}/**/*") + %w(LICENSE.txt README.md)
  #spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  #spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"
  spec.add_runtime_dependency "bundler"
  spec.add_runtime_dependency "thor"
  spec.add_runtime_dependency "yajl-ruby"
  spec.add_runtime_dependency "datasift", '>= 3.0.1'
  spec.add_runtime_dependency "interact"

end
