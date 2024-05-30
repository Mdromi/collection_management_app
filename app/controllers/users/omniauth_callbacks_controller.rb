class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    user = User.from_google(from_google_params)

    if user.persisted?
      sign_out_all_scopes
      flash[:notice] = t "devise.omniauth_callbacks.success", kind: "Google"
      sign_in_and_redirect user, event: :authentication
    else
      flash[:alert] = t "devise.omniauth_callbacks.failure", kind: "Google", reason: "#{auth.info.email} is not authorized."
      redirect_to new_user_session_path
    end
  end

  private

  def from_google_params
    puts "auth.info.name #{auth.info.name}"
    @from_google_params ||= {
      uid: auth.uid,
      email: auth.info.email,
      username: auth.info.name,
      profile_image: auth.info.image,
    }
  end

  def auth
    @auth ||= request.env["omniauth.auth"]
  end
end
