# -*- encoding: utf-8 -*-
# stub: rspec_api_documentation 5.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "rspec_api_documentation".freeze
  s.version = "5.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Chris Cahoon".freeze, "Sam Goldman".freeze, "Eric Oestrich".freeze]
  s.date = "2017-09-27"
  s.description = "Generate API docs from your test suite".freeze
  s.email = ["chris@smartlogicsolutions.com".freeze, "sam@smartlogicsolutions.com".freeze, "eric@smartlogicsolutions.com".freeze]
  s.homepage = "http://smartlogicsolutions.com".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.6.11".freeze
  s.summary = "A double black belt for your docs".freeze

  s.installed_by_version = "2.6.11" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rspec>.freeze, ["~> 3.0"])
      s.add_runtime_dependency(%q<activesupport>.freeze, [">= 3.0.0"])
      s.add_runtime_dependency(%q<mustache>.freeze, [">= 0.99.4", "~> 1.0"])
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.0"])
      s.add_development_dependency(%q<fakefs>.freeze, ["~> 0.4"])
      s.add_development_dependency(%q<sinatra>.freeze, [">= 1.4.4", "~> 1.4"])
      s.add_development_dependency(%q<aruba>.freeze, ["~> 0.5"])
      s.add_development_dependency(%q<capybara>.freeze, ["~> 2.2"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 10.1"])
      s.add_development_dependency(%q<rack-test>.freeze, ["~> 0.6.2"])
      s.add_development_dependency(%q<rack-oauth2>.freeze, [">= 1.0.7", "~> 1.2.2"])
      s.add_development_dependency(%q<webmock>.freeze, ["~> 1.7"])
      s.add_development_dependency(%q<rspec-its>.freeze, ["~> 1.0"])
      s.add_development_dependency(%q<faraday>.freeze, [">= 0.9.0", "~> 0.9"])
      s.add_development_dependency(%q<thin>.freeze, [">= 1.6.3", "~> 1.6"])
    else
      s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
      s.add_dependency(%q<activesupport>.freeze, [">= 3.0.0"])
      s.add_dependency(%q<mustache>.freeze, [">= 0.99.4", "~> 1.0"])
      s.add_dependency(%q<bundler>.freeze, ["~> 1.0"])
      s.add_dependency(%q<fakefs>.freeze, ["~> 0.4"])
      s.add_dependency(%q<sinatra>.freeze, [">= 1.4.4", "~> 1.4"])
      s.add_dependency(%q<aruba>.freeze, ["~> 0.5"])
      s.add_dependency(%q<capybara>.freeze, ["~> 2.2"])
      s.add_dependency(%q<rake>.freeze, ["~> 10.1"])
      s.add_dependency(%q<rack-test>.freeze, ["~> 0.6.2"])
      s.add_dependency(%q<rack-oauth2>.freeze, [">= 1.0.7", "~> 1.2.2"])
      s.add_dependency(%q<webmock>.freeze, ["~> 1.7"])
      s.add_dependency(%q<rspec-its>.freeze, ["~> 1.0"])
      s.add_dependency(%q<faraday>.freeze, [">= 0.9.0", "~> 0.9"])
      s.add_dependency(%q<thin>.freeze, [">= 1.6.3", "~> 1.6"])
    end
  else
    s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
    s.add_dependency(%q<activesupport>.freeze, [">= 3.0.0"])
    s.add_dependency(%q<mustache>.freeze, [">= 0.99.4", "~> 1.0"])
    s.add_dependency(%q<bundler>.freeze, ["~> 1.0"])
    s.add_dependency(%q<fakefs>.freeze, ["~> 0.4"])
    s.add_dependency(%q<sinatra>.freeze, [">= 1.4.4", "~> 1.4"])
    s.add_dependency(%q<aruba>.freeze, ["~> 0.5"])
    s.add_dependency(%q<capybara>.freeze, ["~> 2.2"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.1"])
    s.add_dependency(%q<rack-test>.freeze, ["~> 0.6.2"])
    s.add_dependency(%q<rack-oauth2>.freeze, [">= 1.0.7", "~> 1.2.2"])
    s.add_dependency(%q<webmock>.freeze, ["~> 1.7"])
    s.add_dependency(%q<rspec-its>.freeze, ["~> 1.0"])
    s.add_dependency(%q<faraday>.freeze, [">= 0.9.0", "~> 0.9"])
    s.add_dependency(%q<thin>.freeze, [">= 1.6.3", "~> 1.6"])
  end
end
