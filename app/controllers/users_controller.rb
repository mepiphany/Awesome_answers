class UsersController < ApplicationController

  def new
    @user = User.new
  end
  def create
    user_params = params.require(:user).permit(:first_name, :last_name, :email,
                                               :password, :password_confirmation)
    @user = User.new user_params
    if @user.save
      # will be signed in until you logout
      user_sign_in(@user)
      redirect_to root_path, notice: "Account Created!"
    else
      flash[:alert] = "fail"
      render :new
    end
  end
end
