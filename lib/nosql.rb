# -*- coding: utf-8 -*-

require 'rdiscount'
require 'erubis'

require 'sinatra/base'

require 'sinatra/url_for'
require 'sinatra/static_assets'
require 'sinatra/filler'

module WB
  class NoSQL < Sinatra::Base
    helpers Sinatra::UrlForHelper
    register Sinatra::StaticAssets

    # disable overriding public and views dirs
    set :app_file, __FILE__
    set :static, true

    set :erubis, :pattern => '\{% %\}', :trim => true
    set :markdown, :layout => false

    # the middleware stack can be used internally as well. I'm using it for
    # sessions, logging, and methodoverride. This lets us move stuff out of
    # Sinatra if it's better handled by a middleware component.
    set :logging, true  # use Rack::CommonLogger

    # helper methods
    helpers Sinatra::Filler

    get '/' do
      erubis(markdown(:main))
    end

    get '/:section' do
      erubis(markdown(:"#{params[:section]}"))
    end

    error do
      e = request.env['sinatra.error']
      Kernel.puts e.backtrace.join("\n")
      'Application Error'
    end

    # each Sinatra::Base subclass has its own private middleware stack:
    # use Rack::Lint
  end
end
