# -*- encoding: utf-8 -*-

$: << File.expand_path('../lib', __FILE__)
require 'russian/version'

Gem::Specification.new do |spec|
  spec.name          = "rs_russian"
  spec.version       = Russian::VERSION
  spec.authors       = ["glebtv", "Yaroslav Markin"]
  spec.email         = ["glebtv@gmail.com", "yaroslav@markin.net"]
  spec.description   = %q{Russian language support for Ruby and Rails}
  spec.summary       = %q{Russian language support for Ruby and Rails}
  spec.homepage      = "https://github.com/rs-pro/russian"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'i18n', '~> 1.8'
  spec.add_dependency 'unicode', '~> 0.4.4'
  spec.add_dependency 'activesupport', ['>= 6.1.0']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake', '< 11.0'
  spec.add_development_dependency 'rspec', '~> 2.14'
end
