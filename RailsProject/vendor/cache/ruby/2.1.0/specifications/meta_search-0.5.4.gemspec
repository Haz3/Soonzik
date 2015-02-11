# -*- encoding: utf-8 -*-
# stub: meta_search 0.5.4 ruby lib

Gem::Specification.new do |s|
  s.name = "meta_search"
  s.version = "0.5.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Ernie Miller"]
  s.date = "2010-07-28"
  s.description = "\n      Allows simple search forms to be created against an AR3 model\n      and its associations, has useful view helpers for sort links\n      and multiparameter fields as well.\n    "
  s.email = "ernie@metautonomo.us"
  s.extra_rdoc_files = ["LICENSE", "README.rdoc"]
  s.files = ["LICENSE", "README.rdoc"]
  s.homepage = "http://metautonomo.us/projects/metasearch/"
  s.rdoc_options = ["--charset=UTF-8"]
  s.rubygems_version = "2.4.5"
  s.summary = "ActiveRecord 3 object-based searching for your form_for enjoyment."

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_runtime_dependency(%q<activerecord>, [">= 3.0.0.beta4"])
      s.add_runtime_dependency(%q<activesupport>, [">= 3.0.0.beta4"])
      s.add_runtime_dependency(%q<actionpack>, [">= 3.0.0.beta4"])
      s.add_runtime_dependency(%q<arel>, [">= 0.4.0"])
    else
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<activerecord>, [">= 3.0.0.beta4"])
      s.add_dependency(%q<activesupport>, [">= 3.0.0.beta4"])
      s.add_dependency(%q<actionpack>, [">= 3.0.0.beta4"])
      s.add_dependency(%q<arel>, [">= 0.4.0"])
    end
  else
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<activerecord>, [">= 3.0.0.beta4"])
    s.add_dependency(%q<activesupport>, [">= 3.0.0.beta4"])
    s.add_dependency(%q<actionpack>, [">= 3.0.0.beta4"])
    s.add_dependency(%q<arel>, [">= 0.4.0"])
  end
end
