# -*- encoding: utf-8 -*-
# stub: classy_enum 4.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "classy_enum".freeze
  s.version = "4.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Peter Brown".freeze]
  s.date = "2014-12-28"
  s.description = "A utility that adds class based enum functionality to ActiveRecord attributes".freeze
  s.email = ["github@lette.us".freeze]
  s.homepage = "http://github.com/beerlington/classy_enum".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.6.11".freeze
  s.summary = "A class based enumerator utility for Ruby on Rails".freeze

  s.installed_by_version = "2.6.11" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>.freeze, [">= 3.2"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 2.11.0"])
      s.add_development_dependency(%q<sqlite3>.freeze, ["~> 1.3"])
      s.add_development_dependency(%q<json>.freeze, [">= 1.6"])
    else
      s.add_dependency(%q<activerecord>.freeze, [">= 3.2"])
      s.add_dependency(%q<rspec>.freeze, ["~> 2.11.0"])
      s.add_dependency(%q<sqlite3>.freeze, ["~> 1.3"])
      s.add_dependency(%q<json>.freeze, [">= 1.6"])
    end
  else
    s.add_dependency(%q<activerecord>.freeze, [">= 3.2"])
    s.add_dependency(%q<rspec>.freeze, ["~> 2.11.0"])
    s.add_dependency(%q<sqlite3>.freeze, ["~> 1.3"])
    s.add_dependency(%q<json>.freeze, [">= 1.6"])
  end
end
