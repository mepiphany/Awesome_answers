class FavoritesController < ApplicationController
  before_action :authenticate_user
  def index
    @question = current_user.favored_questions
  end


  def create
    q = Question.find params[:question_id]
    favor = Favorite.new(question: q, user: current_user)
    favor.save
    redirect_to q, notice: "Added to your favorite"
  end

  def destroy
    favor = current_user.favorites.find params[:id] # This will ensure that only the current_user can change the favor
    q = Question.find params[:question_id]
    favor.destroy
    redirect_to q, notice: "removed"

  end





end
