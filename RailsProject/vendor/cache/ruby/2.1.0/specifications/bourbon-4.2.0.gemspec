# -*- encoding: utf-8 -*-
# stub: bourbon 4.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "bourbon"
  s.version = "4.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Andres Mejia", "Chad Mazzola", "Chris Lloyd", "Gabe Berke-Williams", "J. Edward Dewyea", "Jeremy Raines", "Kyle Fiedler", "Matt Jankowski", "Mike Burns", "Nick Quaranto", "Phil LaPier", "Reda Lemeden", "Travis Haynes", "Tyson Gach", "Will McMahan"]
  s.date = "2015-02-07"
  s.description = "Bourbon is a library of pure Sass mixins that are designed to be simple and easy\nto use. No configuration required. The mixins aim to be as vanilla as possible,\nmeaning they should be as close to the original CSS syntax as possible.\n"
  s.email = "design+bourbon@thoughtbot.com"
  s.executables = ["bourbon"]
  s.files = ["bin/bourbon"]
  s.homepage = "http://bourbon.io"
  s.licenses = ["MIT"]
  s.rubyforge_project = "bourbon"
  s.rubygems_version = "2.4.5"
  s.summary = "A simple and lightweight mixin library for Sass"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sass>, ["~> 3.4"])
      s.add_runtime_dependency(%q<thor>, [">= 0"])
      s.add_development_dependency(%q<aruba>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<css_parser>, [">= 0"])
    else
      s.add_dependency(%q<sass>, ["~> 3.4"])
      s.add_dependency(%q<thor>, [">= 0"])
      s.add_dependency(%q<aruba>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<css_parser>, [">= 0"])
    end
  else
    s.add_dependency(%q<sass>, ["~> 3.4"])
    s.add_dependency(%q<thor>, [">= 0"])
    s.add_dependency(%q<aruba>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<css_parser>, [">= 0"])
  end
end
