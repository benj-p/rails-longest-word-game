class GamesController < ApplicationController
  def new
    @letters = []
    alphabet = ('a'..'z').to_a
    10.times { @letters << alphabet.sample }
  end

  def score
    require 'open-uri'
    require 'json'

    @word = params[:word]
    @word_array = @word.split("")
    @letters = params[:letter_list].split(" ")

    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    word_serialized = open(url).read
    @word_dic = JSON.parse(word_serialized)

    def contains_all?(attempt, grid)
      contains = attempt.all? do |letter|
        attempt.count(letter) <= grid.count(letter)
      end
      contains
    end

    if @word_dic["found"] == false
      @message = "not_english"
    elsif contains_all?(@word_array, @letters) == false
      @message = "not_fit"
    else
      @message = "congrats"
      @score = @word.length
    end

    session[:current_user_score] += @score
    @total_score = session[:current_user_score]
  end
end
