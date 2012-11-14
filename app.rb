require 'sinatra'
require 'rest_client'
require 'json'

class Pinboard

  API_URL = 'https://api.pinboard.in/v1/posts/all'

  attr_reader :token

  def initialize(options = {})
    @token = options.fetch(:token) { ENV['PINBOARD_TOKEN'] }

    if token.to_s.empty?
      raise "Missing Pinboard authentication token"
    end
  end

  def all(options = {})
    json = RestClient.get(API_URL, { params: request_params(options) })

    JSON.parse(json).map do |bookmark|
      Bookmark.new(bookmark["description"], bookmark['href'], bookmark['time'])
    end
  end

  def request_params(options)
    default_params.merge!(options)
  end

  def default_params
    {
      format: 'json',
      auth_token: token
    }
  end
end

Bookmark = Struct.new(:description, :href, :time)

class Wishlist
  def items
    Pinboard.new.all(tag: 'wishlist')
  end
end

class BuyJordanStuff < Sinatra::Base
  get '/' do
    @wishlist = Wishlist.new.items

    erb :index
  end
end

