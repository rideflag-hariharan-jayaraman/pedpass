# -*- encoding: utf-8 -*-
# stub: apitome 0.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "apitome".freeze
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["jejacks0n".freeze]
  s.date = "2015-04-12"
  s.description = "API documentation renderer for Rails using RSpec API Documentation JSON output".freeze
  s.email = ["info@modeset.com".freeze]
  s.homepage = "https://github.com/modeset/apitome".freeze
  s.rubygems_version = "2.6.11".freeze
  s.summary = "Apitome: /i\u02C8pit\u0259m\u0113/ An API documentation reader RSpec API Documentation".freeze

  s.installed_by_version = "2.6.11" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<railties>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<rspec_api_documentation>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<kramdown>.freeze, [">= 0"])
    else
      s.add_dependency(%q<railties>.freeze, [">= 0"])
      s.add_dependency(%q<rspec_api_documentation>.freeze, [">= 0"])
      s.add_dependency(%q<kramdown>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<railties>.freeze, [">= 0"])
    s.add_dependency(%q<rspec_api_documentation>.freeze, [">= 0"])
    s.add_dependency(%q<kramdown>.freeze, [">= 0"])
  end
end
