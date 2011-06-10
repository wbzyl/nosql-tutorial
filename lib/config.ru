require 'bundler'

Bundler.require

require 'nosql'

require 'coderay'
require 'rack/codehighlighter'

use Rack::ShowExceptions

use Rack::Codehighlighter, :coderay, :markdown => true, :element => "pre>code"

run WB::NoSQL.new
