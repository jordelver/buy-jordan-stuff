require 'sinatra'

class BuyJordanStuff < Sinatra::Base
  get '/' do
    erb :index
  end
end

