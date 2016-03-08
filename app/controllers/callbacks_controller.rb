class CallbacksController < ApplicationController
  def twitter
    # search for the user with their uid/provider, if we find the user then
    # we log the user in, otherwise, we create a new user account.
    omniauth_data = request.env['omniauth.auth']
    user = User.where(provider: "twitter", uid: omniauth_data["uid"]).first
    if user
      sign_in(user)
      redirect_to root_path, notice: "Sign In!"
    else
      # Create the user account
      user = User.create_from_twitter(omniauth_data)
      sign_in(user)
      redirect_to root_path, notice: "Signed In!"
    end
  end
end

# to refactor
# user ||= User.create_from_twitter(omniauth_data)
# sign_in(user)
# redirect_to root_path, notice: "Signed In!"
