# -*- encoding: utf-8 -*-
# stub: normalize-rails 4.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "normalize-rails".freeze
  s.version = "4.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Nicolas Gallagher".freeze, "Jonathan Neal".freeze, "Mark McConachie".freeze]
  s.date = "2016-04-19"
  s.description = "Normalize.css is an alternative to CSS resets".freeze
  s.email = ["mark@markmcconachie.com".freeze]
  s.homepage = "https://github.com/markmcconachie/normalize-rails".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.6.11".freeze
  s.summary = "Normalize.css is a customisable CSS file that makes browsers render all elements more consistently and in line with modern standards. We researched the differences between default browser styles in order to precisely target only the styles that need normalizing.".freeze

  s.installed_by_version = "2.6.11" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
    else
      s.add_dependency(%q<rake>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>.freeze, [">= 0"])
  end
end
