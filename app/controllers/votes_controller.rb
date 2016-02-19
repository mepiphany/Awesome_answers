class VotesController < ApplicationController
  before_action :authenticate_user

  def create
    question = Question.find params[:question_id]
    vote = Vote.new vote_ params
    vote.user = current_user
    vote.question = question
    flash = (vote.save) ? {notice: "voted!"} : {alert: "tryagain"}
    redirect_to question_path(question), flash
    # if vote.save
    #   redirect_to question_path(question), notice: "voted"
    # else
    #   redirect_to question_path(question), notice: "try again"
    # end

  end

  def update
    question = Question.find params[:question_id]
    vote = Vote.find params[:id]
      vote.update vote_params
      redirect_to question_path(question), notice: "vote updated"
  end

  def destroy
    question = Question.find params[:question_id]
    vote = current_user.vote.find params[:id]
    vote.destroy
    redirect_to question_path(question), notice: "Vote removed"
end

private

  def vote_params
    params.require(:vote).permit(:is_up)
  end

end
