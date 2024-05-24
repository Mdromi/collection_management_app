class Users::RegistrationsController < Devise::RegistrationsController
    protected
  
    def update_resource(resource, params)
      puts "update_resource called"
      if params[:profile_image].present?
        puts "Profile image present"
        encoded_image = Base64.strict_encode64(params[:profile_image].read)
        puts "Encoded image: #{encoded_image[0..30]}..."
        ImageUploadJob.perform_later(resource.class.name, resource.id, :profile_image, encoded_image)
        flash[:success] = "Profile image update is being processed."
        return true
      else
        flash[:error] = "Profile image cannot be blank."
        return false
      end
    end
  
    def account_update_params
      params.require(:user).permit(:profile_image)
    end
  
    def after_update_path_for(resource)
      "/profile"
    end
  end
  