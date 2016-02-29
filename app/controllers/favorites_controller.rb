class FavoritesController < ApplicationController
  before_action :authenticate_user
  def index
    @question = current_user.favored_questions
  end

  def create
    @question = Question.find params[:question_id]
    favor = Favorite.new(question: @question, user: current_user)
    respond_to do |format|
      if favor.save
        format.html { redirect_to @question, notice: "Added to your favorite" }
        format.js { render :successful_favor }
      else
        format.html { redirect_to @question, alert: "like added to your favorite" }
        format.js { render :unsuccessful_favor }
      end
    end
  end

  def destroy
    @question = Question.find params[:question_id]
    favor = current_user.favorites.find params[:id] # This will ensure that only the current_user can change the favor
    favor.destroy
      respond_to do |format|
      format.html { redirect_to @question, notice: "removed" }
      format.js { render }
   end
  end
end
