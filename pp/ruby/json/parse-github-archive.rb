require 'open-uri'
require 'zlib'
require 'pp'

require 'yajl'
require 'yajl/json_gem'

# gz = open('http://data.githubarchive.org/2012-03-31-12.json.gz')

gz = open('githubarchive.json.gz')

js = Zlib::GzipReader.new(gz).read

# Yajl::Parser.new(:symbolize_keys => true).parse(js) do |event|
Yajl::Parser.parse(js) do |event|
  # pp event
  # puts event
  # puts JSON.pretty_generate(event)
  puts Yajl::Encoder.encode(event)
end

__END__
{
  "repository": {
    "url": "https://github.com/dynetk/demo_app",
    "open_issues": 0,
    "watchers": 1,
    "homepage": "",
    "fork": false,
    "has_downloads": true,
    "has_issues": true,
    "forks": 1,
    "size": 0,
    "private": false,
    "name": "demo_app",
    "owner": "dynetk",
    "created_at": "2012/03/18 00:00:05 -0700",
    "has_wiki": true,
    "description": "Ruby on Rails Tutorial Demo Application"
  },
  "actor_attributes": {
    "name": "Raymond Lee",
    "gravatar_id": "7426aa75cb5afc654f42b3f9dba6c2e1",
    "blog": "",
    "type": "User",
    "login": "dynetk"
  },
  "created_at": "2012/03/18 00:00:05 -0700",
  "public": true,
  "actor": "dynetk",
  "payload": {
    "master_branch": "master",
    "ref": null,
    "description": "Ruby on Rails Tutorial Demo Application",
    "ref_type": "repository"
  },
  "url": "https://github.com/dynetk/demo_app",
  "type": "CreateEvent"
}
