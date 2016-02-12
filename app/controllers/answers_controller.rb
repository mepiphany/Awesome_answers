# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  body        :text
#  question_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class AnswersController < ApplicationController
  before_action :authenticate_user

  def create
    # to get question id
    @question = Question.find params[:question_id]
    answer_params = params.require(:answer).permit(:body)
    @answer = Answer.new(answer_params)
    @answer.question = @question
    if @answer.save
      redirect_to question_path(@question), notice: "Answer created!"
    else
      render "/questions/show"
    end
  end
  def destroy
    # question = Question.find params[:question_id]
    # answer = Question.find params[:id]
    answer = Answer.find params[:id]
    redirect_to root_path, alert: "access denied"
    unless can? :manage, answer
    answer.destroy
    redirect_to question_path(params[:question_id]), notice: "Answer deleted"
   end
 end
end
