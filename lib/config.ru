# http://stackoverflow.com/questions/4980877/rails-error-couldnt-parse-yaml
require 'yaml'
YAML::ENGINE.yamler= 'syck'

require 'bundler'

Bundler.require

require 'nosql'

require 'uv'
require 'rack/codehighlighter'

use Rack::ShowExceptions

use Rack::Codehighlighter, :ultraviolet, :markdown => true, :element => "pre>code"

run WB::NoSQL.new
