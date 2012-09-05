require 'rubygems'
require 'bundler'

Bundler.require

require 'sinatra-blog'

require 'sinatra/static_assets'
require 'sinatra/filler'

require 'rack/codehighlighter'


use Rack::Codehighlighter, :coderay, :markdown => true, :element => "pre>code"

class SinatraBlog < Sinatra::Base

  set :root, File.expand_path("../", __FILE__)

  register Sinatra::StaticAssets
  helpers Sinatra::Filler

end

run SinatraBlog
