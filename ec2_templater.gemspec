# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ec2_templater/version'

Gem::Specification.new do |spec|
  spec.name          = 'ec2_templater'
  spec.version       = Ec2Templater::VERSION
  spec.authors       = ['Adam Davies']
  spec.email         = ['adzdavies@gmail.com', 'rubygems@reinteractive.net']

  spec.summary       = 'EC2 service discovery by templating your server config'
  spec.description   = 'Ec2Templater provides a means of EC2 service discovery by templating your server config. It works by periodically querying AWS for the list of running EC2 instances, rendering a template, then running a notify command if it has changed. Using this setup you can provide, for example, a haproxy config that updates based on instances that are available filtered by tag'
  spec.homepage      = "https://github.com/reinteractive/ec2_templater"
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'aws-sdk', '~> 2.2'
  spec.add_runtime_dependency 'erubis',  '~> 2.7'
  spec.add_runtime_dependency 'clamp',   '~> 1.0'

  spec.add_development_dependency 'bundler',    '~> 1.10'
  spec.add_development_dependency 'rake',       '~> 10.0'
  spec.add_development_dependency 'rspec',      '~> 3.4'
  spec.add_development_dependency 'vcr',        '~> 2.9'
  spec.add_development_dependency 'webmock',    '~> 1.24'
  spec.add_development_dependency 'rubocop',    '~> 0.37'
  spec.add_development_dependency 'pry-byebug', '~> 3.3'
end
