# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'org2mindmap/version'

Gem::Specification.new do |spec|
  spec.name          = "org2mindmap"
  spec.version       = Org2mindmap::VERSION
  spec.authors       = ["lds56"]
  spec.email         = ["chenrui.qingqing@gmail.com"]

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end

  spec.summary       = %q{This is a Summary}
  spec.description   = %q{This is a Description}
  spec.homepage      = 'http://nonghao.me'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency 'json', '~> 1.8.2'
  spec.add_runtime_dependency 'nokogiri', '~> 1.6.6.2'
end
