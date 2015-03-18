# -*- encoding: utf-8 -*-
# stub: rdoc-generator-fivefish 0.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "rdoc-generator-fivefish"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Michael Granger"]
  s.cert_chain = ["-----BEGIN CERTIFICATE-----\nMIIDbDCCAlSgAwIBAgIBATANBgkqhkiG9w0BAQUFADA+MQwwCgYDVQQDDANnZWQx\nGTAXBgoJkiaJk/IsZAEZFglGYWVyaWVNVUQxEzARBgoJkiaJk/IsZAEZFgNvcmcw\nHhcNMTMwMjI3MTY0ODU4WhcNMTQwMjI3MTY0ODU4WjA+MQwwCgYDVQQDDANnZWQx\nGTAXBgoJkiaJk/IsZAEZFglGYWVyaWVNVUQxEzARBgoJkiaJk/IsZAEZFgNvcmcw\nggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDb92mkyYwuGBg1oRxt2tkH\n+Uo3LAsaL/APBfSLzy8o3+B3AUHKCjMUaVeBoZdWtMHB75X3VQlvXfZMyBxj59Vo\ncDthr3zdao4HnyrzAIQf7BO5Y8KBwVD+yyXCD/N65TTwqsQnO3ie7U5/9ut1rnNr\nOkOzAscMwkfQxBkXDzjvAWa6UF4c5c9kR/T79iA21kDx9+bUMentU59aCJtUcbxa\n7kcKJhPEYsk4OdxR9q2dphNMFDQsIdRO8rywX5FRHvcb+qnXC17RvxLHtOjysPtp\nEWsYoZMxyCDJpUqbwoeiM+tAHoz2ABMv3Ahie3Qeb6+MZNAtMmaWfBx3dg2u+/WN\nAgMBAAGjdTBzMAkGA1UdEwQCMAAwCwYDVR0PBAQDAgSwMB0GA1UdDgQWBBSZ0hCV\nqoHr122fGKelqffzEQBhszAcBgNVHREEFTATgRFnZWRARmFlcmllTVVELm9yZzAc\nBgNVHRIEFTATgRFnZWRARmFlcmllTVVELm9yZzANBgkqhkiG9w0BAQUFAAOCAQEA\nVlcfyq6GwyE8i0QuFPCeVOwJaneSvcwx316DApjy9/tt2YD2HomLbtpXtji5QXor\nON6oln4tWBIB3Klbr3szq5oR3Rc1D02SaBTalxSndp4M6UkW9hRFu5jn98pDB4fq\n5l8wMMU0Xdmqx1VYvysVAjVFVC/W4NNvlmg+2mEgSVZP5K6Tc9qDh3eMQInoYw6h\nt1YA6RsUJHp5vGQyhP1x34YpLAaly8icbns/8PqOf7Osn9ztmg8bOMJCeb32eQLj\n6mKCwjpegytE0oifXfF8k75A9105cBnNiMZOe1tXiqYc/exCgWvbggurzDOcRkZu\n/YSusaiDXHKU2O3Akc3htA==\n-----END CERTIFICATE-----\n"]
  s.date = "2013-03-26"
  s.description = "A(nother) HTML(5) generator for RDoc.\n\nIt uses {Twitter Bootstrap}[http://twitter.github.com/bootstrap/] for the\npretty, doesn't take up valuable horizontal real estate space with indexes\nand stuff, and has a QuickSilver-like incremental searching."
  s.email = ["ged@FaerieMUD.org"]
  s.extra_rdoc_files = ["History.rdoc", "Manifest.txt", "README.rdoc"]
  s.files = ["History.rdoc", "Manifest.txt", "README.rdoc"]
  s.homepage = "http://deveiate.org/fivefish.html"
  s.licenses = ["BSD"]
  s.rdoc_options = ["--main", "README.rdoc"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.rubyforge_project = "rdoc-generator-fivefish"
  s.rubygems_version = "2.4.5"
  s.summary = "A(nother) HTML(5) generator for RDoc"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<inversion>, ["~> 0.12"])
      s.add_runtime_dependency(%q<loggability>, ["~> 0.6"])
      s.add_runtime_dependency(%q<yajl-ruby>, ["~> 1.1"])
      s.add_runtime_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_development_dependency(%q<hoe-mercurial>, ["~> 1.4.0"])
      s.add_development_dependency(%q<hoe-highline>, ["~> 0.1.0"])
      s.add_development_dependency(%q<hoe-deveiate>, ["~> 0.2"])
      s.add_development_dependency(%q<uglifier>, ["~> 1.2"])
      s.add_development_dependency(%q<less>, ["~> 2.2"])
      s.add_development_dependency(%q<hoe>, ["~> 3.5"])
    else
      s.add_dependency(%q<inversion>, ["~> 0.12"])
      s.add_dependency(%q<loggability>, ["~> 0.6"])
      s.add_dependency(%q<yajl-ruby>, ["~> 1.1"])
      s.add_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_dependency(%q<hoe-mercurial>, ["~> 1.4.0"])
      s.add_dependency(%q<hoe-highline>, ["~> 0.1.0"])
      s.add_dependency(%q<hoe-deveiate>, ["~> 0.2"])
      s.add_dependency(%q<uglifier>, ["~> 1.2"])
      s.add_dependency(%q<less>, ["~> 2.2"])
      s.add_dependency(%q<hoe>, ["~> 3.5"])
    end
  else
    s.add_dependency(%q<inversion>, ["~> 0.12"])
    s.add_dependency(%q<loggability>, ["~> 0.6"])
    s.add_dependency(%q<yajl-ruby>, ["~> 1.1"])
    s.add_dependency(%q<rdoc>, ["~> 4.0"])
    s.add_dependency(%q<hoe-mercurial>, ["~> 1.4.0"])
    s.add_dependency(%q<hoe-highline>, ["~> 0.1.0"])
    s.add_dependency(%q<hoe-deveiate>, ["~> 0.2"])
    s.add_dependency(%q<uglifier>, ["~> 1.2"])
    s.add_dependency(%q<less>, ["~> 2.2"])
    s.add_dependency(%q<hoe>, ["~> 3.5"])
  end
end
