#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'sass'
require './lib/dao'
require './lib/scorer'

set :bind, '0.0.0.0'
set :port, 80

get "/" do
  erb :home
end

get "/mumble" do
  erb :mumble
end

get "/stats" do
  @score_hash = get_score_hash
  erb :stats
end

get "/sorted_stats" do
  @sorted_scores = get_sorted_score
  erb :sorted_stats
end

get "/better-stats" do
  @objectives = get_objectives
  erb :better_stats
end

get "/better-stats/:objective" do
  @objective = params[:objective]
  @objectives = get_objectives
  erb :better_stats
end

get "/map" do
  File.read(File.join('public', 'index.html'))
  #send_file File.read(File.join(settings.public_folder, 'index.html'))
  #erb :map
end

get "/map2" do
  erb :map
end

get "/styles.css" do
  scss :styles
end

not_found do
  @user = get_missing_user
  erb :missing
end
