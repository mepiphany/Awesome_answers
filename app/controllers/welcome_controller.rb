class WelcomeController < ApplicationController
  # we call instance methods defined in a controller 'actions'. We need actions
  # in order to handle user requests.
    def index

    end

    def about
      cookies.signed[:abc] = "xyz"
      cookies.signed[:hello] = "good bye"
      session[:foo] = "bar"

    end

    def greet
      @name = params[:name]
      Rails.logger.info ">>>>>>>>>>"
      Rails.logger.info cookies.signed[:hello]
      Rails.logger.info ">>>>>>>>>>"
    end


end
