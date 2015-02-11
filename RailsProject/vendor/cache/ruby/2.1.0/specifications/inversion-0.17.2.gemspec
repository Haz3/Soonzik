# -*- encoding: utf-8 -*-
# stub: inversion 0.17.2 ruby lib

Gem::Specification.new do |s|
  s.name = "inversion"
  s.version = "0.17.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Michael Granger", "Mahlon E. Smith"]
  s.cert_chain = ["-----BEGIN CERTIFICATE-----\nMIIDbDCCAlSgAwIBAgIBATANBgkqhkiG9w0BAQUFADA+MQwwCgYDVQQDDANnZWQx\nGTAXBgoJkiaJk/IsZAEZFglGYWVyaWVNVUQxEzARBgoJkiaJk/IsZAEZFgNvcmcw\nHhcNMTQwMzE5MDQzNTI2WhcNMTUwMzE5MDQzNTI2WjA+MQwwCgYDVQQDDANnZWQx\nGTAXBgoJkiaJk/IsZAEZFglGYWVyaWVNVUQxEzARBgoJkiaJk/IsZAEZFgNvcmcw\nggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDb92mkyYwuGBg1oRxt2tkH\n+Uo3LAsaL/APBfSLzy8o3+B3AUHKCjMUaVeBoZdWtMHB75X3VQlvXfZMyBxj59Vo\ncDthr3zdao4HnyrzAIQf7BO5Y8KBwVD+yyXCD/N65TTwqsQnO3ie7U5/9ut1rnNr\nOkOzAscMwkfQxBkXDzjvAWa6UF4c5c9kR/T79iA21kDx9+bUMentU59aCJtUcbxa\n7kcKJhPEYsk4OdxR9q2dphNMFDQsIdRO8rywX5FRHvcb+qnXC17RvxLHtOjysPtp\nEWsYoZMxyCDJpUqbwoeiM+tAHoz2ABMv3Ahie3Qeb6+MZNAtMmaWfBx3dg2u+/WN\nAgMBAAGjdTBzMAkGA1UdEwQCMAAwCwYDVR0PBAQDAgSwMB0GA1UdDgQWBBSZ0hCV\nqoHr122fGKelqffzEQBhszAcBgNVHREEFTATgRFnZWRARmFlcmllTVVELm9yZzAc\nBgNVHRIEFTATgRFnZWRARmFlcmllTVVELm9yZzANBgkqhkiG9w0BAQUFAAOCAQEA\nTuL1Bzl6TBs1YEzEubFHb9XAPgehWzzUudjDKzTRd+uyZmxnomBqTCQjT5ucNRph\n3jZ6bhLNooLQxTjIuHodeGcEMHZdt4Yi7SyPmw5Nry12z6wrDp+5aGps3HsE5WsQ\nZq2EuyEOc96g31uoIvjNdieKs+1kE+K+dJDjtw+wTH2i63P7r6N/NfPPXpxsFquo\nwcYRRrHdR7GhdJeT+V8Q8Bi5bglCUGdx+8scMgkkePc98k9osQHypbACmzO+Bqkv\nc7ZKPJcWBv0sm81+FCZXNACn2f9jfF8OQinxVs0O052KbGuEQaaiGIYeuuwQE2q6\nggcrPfcYeTwWlfZPu2LrBg==\n-----END CERTIFICATE-----\n"]
  s.date = "2015-01-23"
  s.description = "Inversion is a templating system for Ruby. It uses the \"Inversion of Control\"\nprinciple to decouple the contents and structure of templates from the code\nthat uses them, making it easier to separate concerns, keep your tests simple,\nand avoid polluting scopes with ephemeral data."
  s.email = ["ged@FaerieMUD.org", "mahlon@martini.nu"]
  s.executables = ["inversion"]
  s.extra_rdoc_files = ["Examples.rdoc", "GettingStarted.rdoc", "Guide.rdoc", "History.rdoc", "Manifest.txt", "README.rdoc", "Tags.rdoc"]
  s.files = ["Examples.rdoc", "GettingStarted.rdoc", "Guide.rdoc", "History.rdoc", "Manifest.txt", "README.rdoc", "Tags.rdoc", "bin/inversion"]
  s.homepage = "http://deveiate.org/projects/Inversion"
  s.licenses = ["BSD"]
  s.rdoc_options = ["--main", "README.rdoc"]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0.0")
  s.rubygems_version = "2.4.5"
  s.summary = "Inversion is a templating system for Ruby"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<loggability>, ["~> 0.11"])
      s.add_development_dependency(%q<hoe-mercurial>, ["~> 1.4"])
      s.add_development_dependency(%q<hoe-manualgen>, ["~> 0.3.0"])
      s.add_development_dependency(%q<hoe-deveiate>, ["~> 0.6"])
      s.add_development_dependency(%q<hoe-highline>, ["~> 0.2"])
      s.add_development_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_development_dependency(%q<highline>, ["~> 1.6"])
      s.add_development_dependency(%q<hoe-bundler>, ["~> 1.2"])
      s.add_development_dependency(%q<rack-test>, ["~> 0.6"])
      s.add_development_dependency(%q<simplecov>, ["~> 0.8"])
      s.add_development_dependency(%q<sinatra>, ["~> 1.4"])
      s.add_development_dependency(%q<tilt>, ["~> 2.0"])
      s.add_development_dependency(%q<sysexits>, ["~> 1.0"])
      s.add_development_dependency(%q<trollop>, ["~> 2.0"])
      s.add_development_dependency(%q<rdoc-generator-fivefish>, ["~> 0"])
      s.add_development_dependency(%q<hoe>, ["~> 3.13"])
    else
      s.add_dependency(%q<loggability>, ["~> 0.11"])
      s.add_dependency(%q<hoe-mercurial>, ["~> 1.4"])
      s.add_dependency(%q<hoe-manualgen>, ["~> 0.3.0"])
      s.add_dependency(%q<hoe-deveiate>, ["~> 0.6"])
      s.add_dependency(%q<hoe-highline>, ["~> 0.2"])
      s.add_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_dependency(%q<highline>, ["~> 1.6"])
      s.add_dependency(%q<hoe-bundler>, ["~> 1.2"])
      s.add_dependency(%q<rack-test>, ["~> 0.6"])
      s.add_dependency(%q<simplecov>, ["~> 0.8"])
      s.add_dependency(%q<sinatra>, ["~> 1.4"])
      s.add_dependency(%q<tilt>, ["~> 2.0"])
      s.add_dependency(%q<sysexits>, ["~> 1.0"])
      s.add_dependency(%q<trollop>, ["~> 2.0"])
      s.add_dependency(%q<rdoc-generator-fivefish>, ["~> 0"])
      s.add_dependency(%q<hoe>, ["~> 3.13"])
    end
  else
    s.add_dependency(%q<loggability>, ["~> 0.11"])
    s.add_dependency(%q<hoe-mercurial>, ["~> 1.4"])
    s.add_dependency(%q<hoe-manualgen>, ["~> 0.3.0"])
    s.add_dependency(%q<hoe-deveiate>, ["~> 0.6"])
    s.add_dependency(%q<hoe-highline>, ["~> 0.2"])
    s.add_dependency(%q<rdoc>, ["~> 4.0"])
    s.add_dependency(%q<highline>, ["~> 1.6"])
    s.add_dependency(%q<hoe-bundler>, ["~> 1.2"])
    s.add_dependency(%q<rack-test>, ["~> 0.6"])
    s.add_dependency(%q<simplecov>, ["~> 0.8"])
    s.add_dependency(%q<sinatra>, ["~> 1.4"])
    s.add_dependency(%q<tilt>, ["~> 2.0"])
    s.add_dependency(%q<sysexits>, ["~> 1.0"])
    s.add_dependency(%q<trollop>, ["~> 2.0"])
    s.add_dependency(%q<rdoc-generator-fivefish>, ["~> 0"])
    s.add_dependency(%q<hoe>, ["~> 3.13"])
  end
end
