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
  before_action :authenticate_user, except: [:index]

  def index
    @question = Question.find params[:question_id]
        render json: @question.answers
  end

  def create
    # to get question id
    @question = Question.find params[:question_id]
    answer_params = params.require(:answer).permit(:body)
    @answer = Answer.new(answer_params)
    @answer.question = @question
    @answer.user = current_user
    respond_to do |format|
    if @answer.save
      AnswersMailer.notify_question_owner(@answer).deliver_later
      format.html {redirect_to question_path(@question), notice: "Answer created!"}
      format.js { render :create_success }
    else
      format.html { render "/questions/show" }
      format.js { render :create_failure }
    end
   end
  end
  def destroy
    # question = Question.find params[:question_id]
    # answer = Question.find params[:id]
    @answer = Answer.find params[:id]
    redirect_to root_path, alert: "Access denied" unless can? :manage, @answer
    @answer.destroy
    respond_to do |format|
    format.html { redirect_to question_path(params[:question_id]), notice: "Answer deleted!" }
    format.js { render } # this renders /app/views/answers/destroy.js.erb

   end
 end
end
