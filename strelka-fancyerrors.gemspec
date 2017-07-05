# -*- encoding: utf-8 -*-
# stub: strelka-fancyerrors 0.1.0.pre20170705094112 ruby lib

Gem::Specification.new do |s|
  s.name = "strelka-fancyerrors".freeze
  s.version = "0.1.0.pre20170705094112"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Michael Granger".freeze]
  s.date = "2017-07-05"
  s.description = "Strelka-FancyErrors is a Strelka plugin for rendering a bunch of useful\ninformation on error responses suitable for developers.".freeze
  s.email = ["ged@FaerieMUD.org".freeze]
  s.extra_rdoc_files = ["History.rdoc".freeze, "Manifest.txt".freeze, "README.rdoc".freeze, "History.rdoc".freeze, "README.rdoc".freeze]
  s.files = ["ChangeLog".freeze, "History.rdoc".freeze, "Manifest.txt".freeze, "README.rdoc".freeze, "Rakefile".freeze, "data/strelka-fancyerrors/templates/client-error.tmpl".freeze, "data/strelka-fancyerrors/templates/error-layout.tmpl".freeze, "data/strelka-fancyerrors/templates/server-error.tmpl".freeze, "lib/strelka/app/fancyerrors.rb".freeze, "spec/strelka/app/fancyerrors_spec.rb".freeze]
  s.homepage = "http://deveiate.org/projects/strelka/fancyerrors.html".freeze
  s.licenses = ["BSD-3-Clause".freeze]
  s.rdoc_options = ["--main".freeze, "README.rdoc".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.3.4".freeze)
  s.rubygems_version = "2.6.12".freeze
  s.summary = "Strelka-FancyErrors is a Strelka plugin for rendering a bunch of useful information on error responses suitable for developers.".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<strelka>.freeze, ["~> 0.15"])
      s.add_runtime_dependency(%q<inversion>.freeze, ["~> 1.0"])
      s.add_runtime_dependency(%q<loggability>.freeze, ["~> 0.14"])
      s.add_development_dependency(%q<hoe-mercurial>.freeze, ["~> 1.4"])
      s.add_development_dependency(%q<hoe-deveiate>.freeze, ["~> 0.9"])
      s.add_development_dependency(%q<hoe-highline>.freeze, ["~> 0.2"])
      s.add_development_dependency(%q<rdoc>.freeze, ["~> 4.0"])
      s.add_development_dependency(%q<hoe>.freeze, ["~> 3.16"])
    else
      s.add_dependency(%q<strelka>.freeze, ["~> 0.15"])
      s.add_dependency(%q<inversion>.freeze, ["~> 1.0"])
      s.add_dependency(%q<loggability>.freeze, ["~> 0.14"])
      s.add_dependency(%q<hoe-mercurial>.freeze, ["~> 1.4"])
      s.add_dependency(%q<hoe-deveiate>.freeze, ["~> 0.9"])
      s.add_dependency(%q<hoe-highline>.freeze, ["~> 0.2"])
      s.add_dependency(%q<rdoc>.freeze, ["~> 4.0"])
      s.add_dependency(%q<hoe>.freeze, ["~> 3.16"])
    end
  else
    s.add_dependency(%q<strelka>.freeze, ["~> 0.15"])
    s.add_dependency(%q<inversion>.freeze, ["~> 1.0"])
    s.add_dependency(%q<loggability>.freeze, ["~> 0.14"])
    s.add_dependency(%q<hoe-mercurial>.freeze, ["~> 1.4"])
    s.add_dependency(%q<hoe-deveiate>.freeze, ["~> 0.9"])
    s.add_dependency(%q<hoe-highline>.freeze, ["~> 0.2"])
    s.add_dependency(%q<rdoc>.freeze, ["~> 4.0"])
    s.add_dependency(%q<hoe>.freeze, ["~> 3.16"])
  end
end
