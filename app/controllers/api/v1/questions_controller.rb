class Api::V1::QuestionsController < ApplicationController
  def index
    @questions = Question.order("created_at DESC").limit(10)
    # render json: @questions
    # will render /api/v1/questions/index.json.jbuilder
  end

  def show
   @question = Question.find params[:id]
   # send JSON that has:
   # all attributes of the question
   # list of answers (JSON array)
   # list of tags (JSON array)
  end

end
