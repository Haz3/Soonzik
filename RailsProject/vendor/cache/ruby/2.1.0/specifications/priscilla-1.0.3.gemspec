# -*- encoding: utf-8 -*-
# stub: priscilla 1.0.3 ruby lib

Gem::Specification.new do |s|
  s.name = "priscilla"
  s.version = "1.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Ju Liu"]
  s.date = "2014-04-03"
  s.description = "Don't let your console messages drown in a wall of text, make them stand out"
  s.email = ["ju.liu@welaika.com"]
  s.homepage = "http://github.com/Arkham/priscilla"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.5"
  s.summary = "Frock up your console messages"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<colorize>, ["~> 0.7"])
      s.add_runtime_dependency(%q<rumoji>, ["~> 0.3"])
      s.add_development_dependency(%q<bundler>, ["~> 1.5"])
      s.add_development_dependency(%q<rake>, ["~> 10.1"])
      s.add_development_dependency(%q<rspec>, ["~> 2.14"])
    else
      s.add_dependency(%q<colorize>, ["~> 0.7"])
      s.add_dependency(%q<rumoji>, ["~> 0.3"])
      s.add_dependency(%q<bundler>, ["~> 1.5"])
      s.add_dependency(%q<rake>, ["~> 10.1"])
      s.add_dependency(%q<rspec>, ["~> 2.14"])
    end
  else
    s.add_dependency(%q<colorize>, ["~> 0.7"])
    s.add_dependency(%q<rumoji>, ["~> 0.3"])
    s.add_dependency(%q<bundler>, ["~> 1.5"])
    s.add_dependency(%q<rake>, ["~> 10.1"])
    s.add_dependency(%q<rspec>, ["~> 2.14"])
  end
end
