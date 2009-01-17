# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rimapub}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["FIXME full name"]
  s.date = %q{2009-01-17}
  s.description = %q{* GEM package that allows publishing image files to several online sites at ones. Acts like Shozu.  * Command line executable rimapub allows publishing images to onlines sites from the command line.}
  s.email = ["FIXME email"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc", "website/index.txt"]
  s.files = ["History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc", "Rakefile", "config/website.yml.sample", "lib/rimapub.rb", "lib/rimapub/rimapub.rb", "lib/rimapub/rimapub_service.rb", "lib/rimapub/rimapub_set.rb", "script/console", "script/destroy", "script/generate", "script/txt2html", "spec/rimapub_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "tasks/rspec.rake", "website/index.html", "website/index.txt", "website/javascripts/rounded_corners_lite.inc.js", "website/stylesheets/screen.css", "website/template.html.erb"]
  s.has_rdoc = true
  s.homepage = %q{http://wiki.github.com/jmcarbo/rimapub}
  s.post_install_message = %q{PostInstall.txt}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rimapub}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{* GEM package that allows publishing image files to several online sites at ones}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<newgem>, [">= 1.2.3"])
      s.add_development_dependency(%q<hoe>, [">= 1.8.0"])
    else
      s.add_dependency(%q<newgem>, [">= 1.2.3"])
      s.add_dependency(%q<hoe>, [">= 1.8.0"])
    end
  else
    s.add_dependency(%q<newgem>, [">= 1.2.3"])
    s.add_dependency(%q<hoe>, [">= 1.8.0"])
  end
end
