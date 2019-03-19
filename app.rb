require 'sinatra/base'
require 'sinatra/r18n'
require "instagram"
require 'yt'
require_relative "./cache.rb"


class App < Sinatra::Base
  require 'sinatra/reloader' if development?

  configure {
    set :server, :puma
  }

  set :static, true
  set :public_dir, './public'
  set :root, File.dirname(__FILE__)

  register Sinatra::R18n

  before do
    session[:locale] = ENV['APP_LANG']
    @path_info = request.path_info
  end

  # ROUTER
  get '/' do
    erb :index
  end

  get '/band' do
    erb :band
  end

  get '/music' do
    @data = YAML.load_file("./data/music.yml")["disks"].reverse
    erb :music
  end

  get '/photos' do
    @data = Cache.fetch('photos-cache', 3600) do
      Instagram.client(access_token: ENV["INSTAGRAM_TOKEN"]).user_recent_media
    end
    erb :photos
  end

  get '/videos' do
    @videos = Cache.fetch('videos-cache', 3600) do
      ::Yt.configuration.api_key = ENV["YOUTUBE_KEY"]
      channel = ::Yt::Channel.new(id: "UCK-CRSAuJoMmSyKFFPtJphw")
      channel.videos.map { |v| v.embed_html }
    end
    erb :videos
  end

  # not_found do
  #   redirect '/404.html'
  # end

  helpers do
    def active_class(path = '')
      if request.path_info == "/#{path}"
        'active'
      else
        ''
      end
    end

    def title
      "Elterium — Instrumental Rock from cold Siberia: #{request.path_info.gsub("/", "").capitalize}"
    end
  end

end
