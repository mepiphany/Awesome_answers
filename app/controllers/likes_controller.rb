class LikesController < ApplicationController
  before_action :authenticate_user

  def create
    @question = Question.find params[:question_id]
    like = Like.new(question: @question, user: current_user)
    respond_to do |format|
       if like.save
         format.html { redirect_to @question, notice: "Liked!" }
         format.js   { render :successfully_liked }
       else
         format.html { redirect_to @question, alert: "Not Liked!" }
         format.js   { render :unsuccessfully_liked };
       end
     end
   end

  def destroy
    like = current_user.likes.find params[:id]
    @question    = Question.find params[:question_id]
    like.destroy
    respond_to do |format|
       format.html { redirect_to question_path(@question), notice: "Un-liked!" }
       format.js   { render }
     end
   end
end
