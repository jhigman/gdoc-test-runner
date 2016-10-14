require 'rubygems'
require 'data_mapper'
require 'dm-core'
require 'dm-redis-adapter'
require 'sinatra'
require 'sinatra/config_file'
require 'yaml'
require 'haml'
require 'google/api_client'
require 'google_drive'
require 'csv'
require 'json'
require 'jsonpath'
require 'rest_client'
require 'redis'
require 'resque'

configure(:development) do
  require 'rspec'
  require 'byebug'
end

require_relative 'models/init'
require_relative 'routes/init'

config_file 'config/config.yml'


class SpratTestRunner < Sinatra::Application

  enable :sessions

  set :session_secret, 'my sooper secret'

  if ENV["REDISCLOUD_URL"]
    uri = URI.parse(ENV["REDISCLOUD_URL"])
    redis = Redis.new(host: uri.host, port: uri.port, password: uri.password)
    DataMapper.setup :default, { adapter: 'redis', host: uri.host, port: uri.port, password: uri.password}
  else
    redis = Redis.new
    DataMapper.setup :default, { adapter: 'redis' }
  end

  Resque.redis = redis

  set :store, Sprat::Store.new(redis)

  DataMapper.finalize

  DataMapper::Model.raise_on_save_failure = true

  DataMapper.auto_migrate!

end
