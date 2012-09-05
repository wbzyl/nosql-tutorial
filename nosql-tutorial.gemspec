# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["Wlodek Bzyl"]
  gem.email         = ["matwb@ug.gda.pl"]
  gem.description = %q{Notatki do wykładu „NoSQL data persistence”. 2012/2013}
  gem.summary     = %q{Notatki do wykładu „NoSQL data persistence”}
  gem.homepage      = "http://tao.inf.ug.edu.pl"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "nosql-tutorial"
  gem.require_paths = ["lib"]

  gem.version       = "1.0.1"

  gem.add_runtime_dependency 'rubygems-bundler'

  gem.add_runtime_dependency 'sinatra-blog'
  gem.add_runtime_dependency 'rack-codehighlighter'

  gem.add_runtime_dependency 'sinatra-static-assets'
  gem.add_runtime_dependency 'sinatra-filler'
end
