class Users::RegistrationsController < Devise::RegistrationsController
  protected

  def update_resource(resource, params)
    puts "update_resource called"
    if params[:profile_image].present?
      # Encode the image data as base64
      encoded_image = Base64.strict_encode64(params[:profile_image].read)

      # Upload the image to imgbb
      imgbb_response = upload_image_to_imgbb(encoded_image)

      if imgbb_response && imgbb_response["data"] && imgbb_response["data"]["url"]
        # Update the profile image URL in the resource
        resource.profile_image = imgbb_response["data"]["url"]
      else
        flash[:error] = "Failed to upload profile image."
        return false
      end
    else
      flash[:error] = "Profile image cannot be blank."
      return false
    end

    # Save the updated resource
    if resource.save
      flash[:success] = "Profile image updated successfully."
      return true
    else
      flash[:error] = resource.errors.full_messages.to_sentence
      return false
    end
  end

  def account_update_params
    params.require(:user).permit(:profile_image)
  end

  def after_update_path_for(resource)
      "/profile"
  end

  private

  def upload_image_to_imgbb(image_data)
    url = URI.parse("https://api.imgbb.com/1/upload")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request.set_form_data({
      "key" => ENV["IMGBB_API_KEY"],
      "image" => image_data,
    })

    response = http.request(request)
    JSON.parse(response.body)
  end
end
