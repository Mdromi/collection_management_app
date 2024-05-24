# app/controllers/users/registrations_controller.rb

class Users::RegistrationsController < Devise::RegistrationsController
  include ImageUploadable

  protected

  def update_resource(resource, params)
    if params[:profile_image].present?
      encoded_image = Base64.strict_encode64(params[:profile_image].read)
      Rails.logger.info "Encoded image: #{encoded_image[0..30]}..."

      # Call the upload_image_to_imgbb method directly
      imgbb_response = upload_image_to_imgbb(encoded_image)
      if imgbb_response && imgbb_response["data"] && imgbb_response["data"]["url"]
        resource.profile_image = imgbb_response["data"]["url"]
        if resource.save
          Rails.logger.info "Profile image updated successfully for user #{resource.id}"
          flash[:success] = "Profile image updated successfully."
        else
          Rails.logger.error "Failed to save profile image for user #{resource.id}: #{resource.errors.full_messages.to_sentence}"
          flash[:error] = "Failed to update profile image."
        end
      else
        Rails.logger.error "Failed to upload profile image for user #{resource.id}"
        flash[:error] = "Failed to upload profile image."
      end
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
