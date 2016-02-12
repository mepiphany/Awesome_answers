# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  title      :string
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  view_count :integer
#

class QuestionsController < ApplicationController
  # This 'before_action' will call the 'find_question' method before executing
  # any other action.
  # We can specify :only or "except" to be more specific about the actions
  # which the before_action apply to
  # before_action :find_question, except: [:new, :create, :index]
  before_action :find_question, only: [:show, :edit, :update, :destroy]

  before_action :authenticate_user, except: [:index, :show]

  before_action :authorize_user, only: [:edit, :update, :destory]



  def new
    @question = Question.new
  end

  def create
    # params => {"question"=>{"title"=>"hello world", "body"=>"something here"}}
  #  question       = Question.new
  #  question.title = params[:question][:title]
  #  question.body  = params[:question][:body]
#---------------------------------------------------------------------------------------------#
  # using params. require ensures that there is a key called 'question' in my
  # params. the 'permit' method will only allow paramsters that you explicitly
  # list, in this case: title and body
  # This is called a Strong parameter
  #  question_params = params.require(:question).permit([:title, :body])

  # We made a method!!!
#--------------------------------------------------------------------------------------------#
   @question = Question.new question_params
   @question.user = current_user
   # When you .save it will return 'save' or 'false'
   # if i need to access data use render, however, if you need new url to capture info use redirect
   if @question.save
    # All these formats are possible ways to redirect in Rails:
    #  redirect_to question_path({id: @question.id})
    #  redirect_to question_path({id: @question})
    #  redirect_to @question
    flash[:notice] = "Question Created Successfully!"
    redirect_to question_path(@question)
   else
   # This will render app/views/questions/new.html.erb template
   # we need to be explict about rendering the new template because the
   # default behavior is to render 'create.html.erb'
   # you can specify full path such as: render "/questions/new"
   flash[:alert] = "Question wasn't created. Check errors below"
   render :new
  end
 end
 # GET: /question/13
  def show
    @question.view_count += 1
    @question.save
    @answer = Answer.new
  end
  # listings page
  def index
    @questions = Question.all
  end

  def edit
    # we need to find the question that will be edited
    # This is a conditional where if the current_user does not match the
    # @question.user go back to the root_path
    if @question.user != current_user
      redirect_to root_path, alert: "access denied!"
    end

  end

  def update
    # we need to fetch the question first to update it
    # We call the update with sanitized params
    if @question.update question_params #This statement will return true or false(acting like .save)
    # we redirect to the question show page
      redirect_to(question_path(@question), {notice: "question updated"})
    else
      render :edit
    end


end

  def destroy
    # IF you use Delete, it will skip all the call backs and will delete the
    @question.destroy
    # we redirect to the index page
    redirect_to questions_path, notice: "Question Deleted!"

  end

  private

  def question_params
    # using params. require ensures that there is a key called 'question' in my
    # params. the 'permit' method will only allow paramsters that you explicitly
    # list, in this case: title and body
    # This is called a Strong parameter
    # we must use strong params to only allow updating the title / body

     question_params = params.require(:question).permit([:title, :body, :category_id])
  end
  def find_question
    @question = Question.find params[:id]
  end

  def authenticate_user
    # if session[:user:id] is nil we redirect to the sign in page
    unless session[:user_id]
      redirect_to new_session_path, notice: "Please log in!"
    end
  end

  def authorize_user
    # This is a conditional where if the current_user does not match the
    # @question.user go back to the root_path
    unless can? :manage, @question #@question.user != current_user
      redirect_to root_path, alert: "access denied!"
    end
  end
end
