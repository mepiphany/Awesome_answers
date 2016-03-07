class Api::V1::QuestionsController < Api::BaseController

  def create
    def create
      # params => {"question"=>{"title"=>"hello world", "body"=>"something here"}}
      # question       = Question.new
      # question.title = params[:question][:title]
      # question.body  = params[:question][:body]

      @question      = Question.new question_params
      @question.user = current_user
      if @question.save
        # all these formats are possible ways to redirect in Rails:
        # redirect_to question_path({id: @question.id})
        # redirect_to question_path({id: @question})
        # redirect_to @question
        flash[:notice] = "Question Created Successfully!"
        redirect_to question_path(@question)
      else
        # This will render app/views/questions/new.html.erb template
        # we need to be explicit about rendering the new template becuase the
        # default behaviour is to render `create.html.erb`
        # you can specify full path such as: render "/questions/new"
        flash[:alert] = "Question wasn't created. Check errors below"
        render :new
      end
    end
  end

  def index
    @questions = Question.order("created_at DESC").limit(10)
    # render json: @questions
    # will render /api/v1/questions/index.json.jbuilder
    # render json: @questions
  end

  def show
    @question = Question.find params[:id]
    # send JSON that has:
    # all attributes of the question
    # list of answers (JSON array)
    # list of tags (JSON array)
    render json: @question
  end

  def create
    question_params = params.require(:question).permit(:title, :body)
    question        = Question.new question_params
    question.user   = @user
    if question.save
      head :ok
    else
      render json: {errors: question.errors.full_messages}
    end
  end
end
