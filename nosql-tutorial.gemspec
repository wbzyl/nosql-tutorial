# -*- encoding: utf-8 -*-

$:.push File.expand_path("../lib", __FILE__)
require "version"

Gem::Specification.new do |s|
  s.name        = "nosql-tutorial"
  s.version     = Nosql::Tutorial::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Włodek Bzyl"]
  s.email       = ["matwb@ug.edu.pl"]
  s.homepage    = "http://inf.ug.edu.pl/~wbzyl"
  s.summary     = %q{Notatki do wykładu „NoSQL data persistence”}
  s.description = %q{Notatki do wykładu „NoSQL data persistence”. 2010/2011}

  s.rubyforge_project = "nosql-tutorial"

  s.add_runtime_dependency 'sinatra'
  s.add_runtime_dependency 'rdiscount'
  s.add_runtime_dependency 'erubis'

  s.add_runtime_dependency 'sinatra-static-assets'
  s.add_runtime_dependency 'emk-sinatra-url-for'
  s.add_runtime_dependency 'sinatra-filler'

  # does not work with ruby 1.9.2
  s.add_runtime_dependency 'ultraviolet'
# s.add_runtime_dependency 'rack-codehighlighter'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
