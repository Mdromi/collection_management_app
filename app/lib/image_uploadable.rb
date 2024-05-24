# app/lib/image_uploadable.rb

module ImageUploadable
  def upload_image_to_cloudinary(image_data)
    Cloudinary::Uploader.upload("data:image/png;base64,#{image_data}")
  end
end
