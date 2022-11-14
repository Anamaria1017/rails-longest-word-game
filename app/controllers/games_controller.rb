require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.shuffle[0,10].join
  end

  def score
    session[:points] = session[:points] || 0
    @points = session[:points]
    # 1. Get info if word exists or not
    @input = params[:input]
    url = "https://wagon-dictionary.herokuapp.com/#{@input}"
    api_response = URI.open(url)
    json = JSON.parse(api_response.read)
    @word_exists = json['found']

    # Check if word is built with letters + Score calculation
    @letters = params[:letters]
    # Include?
    @letters_arr = @letters.chars.sort
    @input_arr = @input.chars.sort
    @include = @input_arr.all? { |element| @input_arr.count(element) <= @letters_arr.count(element) }
    if @include == true
      if @word_exists == true
        session[:points] += @input_arr.size * 2
        @result = "Congratulations! #{@input} is a valid English word. You earned #{session[:points]} points!"
      else
        @result = "Sorry but #{@input} does not seem to be an English word..."
      end
    else
      @result = "Sorry but #{@input} can't be built out of #{@letters}"
    end
  end
end
