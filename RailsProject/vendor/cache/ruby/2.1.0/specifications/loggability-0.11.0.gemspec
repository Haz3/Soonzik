# -*- encoding: utf-8 -*-
# stub: loggability 0.11.0 ruby lib

Gem::Specification.new do |s|
  s.name = "loggability"
  s.version = "0.11.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Michael Granger"]
  s.cert_chain = ["-----BEGIN CERTIFICATE-----\nMIIDbDCCAlSgAwIBAgIBATANBgkqhkiG9w0BAQUFADA+MQwwCgYDVQQDDANnZWQx\nGTAXBgoJkiaJk/IsZAEZFglGYWVyaWVNVUQxEzARBgoJkiaJk/IsZAEZFgNvcmcw\nHhcNMTQwMzE5MDQzNTI2WhcNMTUwMzE5MDQzNTI2WjA+MQwwCgYDVQQDDANnZWQx\nGTAXBgoJkiaJk/IsZAEZFglGYWVyaWVNVUQxEzARBgoJkiaJk/IsZAEZFgNvcmcw\nggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDb92mkyYwuGBg1oRxt2tkH\n+Uo3LAsaL/APBfSLzy8o3+B3AUHKCjMUaVeBoZdWtMHB75X3VQlvXfZMyBxj59Vo\ncDthr3zdao4HnyrzAIQf7BO5Y8KBwVD+yyXCD/N65TTwqsQnO3ie7U5/9ut1rnNr\nOkOzAscMwkfQxBkXDzjvAWa6UF4c5c9kR/T79iA21kDx9+bUMentU59aCJtUcbxa\n7kcKJhPEYsk4OdxR9q2dphNMFDQsIdRO8rywX5FRHvcb+qnXC17RvxLHtOjysPtp\nEWsYoZMxyCDJpUqbwoeiM+tAHoz2ABMv3Ahie3Qeb6+MZNAtMmaWfBx3dg2u+/WN\nAgMBAAGjdTBzMAkGA1UdEwQCMAAwCwYDVR0PBAQDAgSwMB0GA1UdDgQWBBSZ0hCV\nqoHr122fGKelqffzEQBhszAcBgNVHREEFTATgRFnZWRARmFlcmllTVVELm9yZzAc\nBgNVHRIEFTATgRFnZWRARmFlcmllTVVELm9yZzANBgkqhkiG9w0BAQUFAAOCAQEA\nTuL1Bzl6TBs1YEzEubFHb9XAPgehWzzUudjDKzTRd+uyZmxnomBqTCQjT5ucNRph\n3jZ6bhLNooLQxTjIuHodeGcEMHZdt4Yi7SyPmw5Nry12z6wrDp+5aGps3HsE5WsQ\nZq2EuyEOc96g31uoIvjNdieKs+1kE+K+dJDjtw+wTH2i63P7r6N/NfPPXpxsFquo\nwcYRRrHdR7GhdJeT+V8Q8Bi5bglCUGdx+8scMgkkePc98k9osQHypbACmzO+Bqkv\nc7ZKPJcWBv0sm81+FCZXNACn2f9jfF8OQinxVs0O052KbGuEQaaiGIYeuuwQE2q6\nggcrPfcYeTwWlfZPu2LrBg==\n-----END CERTIFICATE-----\n"]
  s.date = "2014-04-14"
  s.description = "A composable logging system built on the standard Logger library.\n\nYou can add Loggability to large libraries and systems, then hook everything\nup later when you know where you want logs to be written, at what level of\nseverity, and in which format.\n\nAn example:\n\n    # Load a bunch of libraries that use Loggability\n    require 'strelka'\n    require 'inversion'\n    require 'treequel'\n    require 'loggability'\n    \n    # Set up our own library\n    module MyProject\n        extend Loggability\n        log_as :my_project\n    \n        class Server\n            extend Loggability\n            log_to :my_project\n    \n            def initialize\n                self.log.debug \"Listening.\"\n            end\n        end\n    \n    end\n    \n    # Now tell everything that's using Loggability to log to an HTML\n    # log file at INFO level\n    Loggability.write_to( '/usr/local/www/htdocs/log.html' )\n    Loggability.format_as( :html )\n    Loggability.level = :info"
  s.email = ["ged@FaerieMUD.org"]
  s.extra_rdoc_files = ["History.rdoc", "Manifest.txt", "README.rdoc"]
  s.files = ["History.rdoc", "Manifest.txt", "README.rdoc"]
  s.homepage = "http://deveiate.org/projects/loggability"
  s.licenses = ["Ruby"]
  s.rdoc_options = ["--main", "README.rdoc"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.rubygems_version = "2.4.5"
  s.summary = "A composable logging system built on the standard Logger library"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<hoe-mercurial>, ["~> 1.4.0"])
      s.add_development_dependency(%q<hoe-deveiate>, ["~> 0.5"])
      s.add_development_dependency(%q<hoe-highline>, ["~> 0.2"])
      s.add_development_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_development_dependency(%q<hoe-bundler>, ["~> 1.2"])
      s.add_development_dependency(%q<simplecov>, ["~> 0.7"])
      s.add_development_dependency(%q<configurability>, ["~> 2.0"])
      s.add_development_dependency(%q<hoe>, ["~> 3.11"])
    else
      s.add_dependency(%q<hoe-mercurial>, ["~> 1.4.0"])
      s.add_dependency(%q<hoe-deveiate>, ["~> 0.5"])
      s.add_dependency(%q<hoe-highline>, ["~> 0.2"])
      s.add_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_dependency(%q<hoe-bundler>, ["~> 1.2"])
      s.add_dependency(%q<simplecov>, ["~> 0.7"])
      s.add_dependency(%q<configurability>, ["~> 2.0"])
      s.add_dependency(%q<hoe>, ["~> 3.11"])
    end
  else
    s.add_dependency(%q<hoe-mercurial>, ["~> 1.4.0"])
    s.add_dependency(%q<hoe-deveiate>, ["~> 0.5"])
    s.add_dependency(%q<hoe-highline>, ["~> 0.2"])
    s.add_dependency(%q<rdoc>, ["~> 4.0"])
    s.add_dependency(%q<hoe-bundler>, ["~> 1.2"])
    s.add_dependency(%q<simplecov>, ["~> 0.7"])
    s.add_dependency(%q<configurability>, ["~> 2.0"])
    s.add_dependency(%q<hoe>, ["~> 3.11"])
  end
end
