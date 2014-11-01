require "sinatra"
require "aws"

if ENV["RACK_ENV"] != "production"
  require 'dotenv'
  Dotenv.load
end

Dir.glob("lib/*").each { |path| require_relative path }

class VideoApp < Sinatra::Base

  get "/" do
    @lectures = Lecture.all
    erb :index
  end

  get "/:key" do
    @lecture = Lecture.find(params[:key])
    erb :show
  end
end
