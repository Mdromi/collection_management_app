# app/lib/image_uploadable.rb

module ImageUploadable
  def upload_image_to_cloudinary(image_data)
    Cloudinary::Uploader.upload("data:image/png;base64,#{image_data}")
  end

  def delete_image_from_cloudinary(image_url)
    # Parse the image URL to extract the public ID
    public_id = extract_public_id_from_url(image_url)
    puts "public_id #{public_id}"

    if public_id.present?
      # Delete the image from Cloudinary using the extracted public ID
      result = Cloudinary::Uploader.destroy(public_id)
      puts "result #{result}"

      # Check if the deletion was successful
      if result['result'] == 'ok'
        puts "Image deleted successfully"
      else
        puts "Failed to delete image: #{result['error']}"
      end
    else
      puts "Failed to extract public ID from image URL"
    end
  end

  private

  def extract_public_id_from_url(image_url)
    parts = image_url.split('/')
    parts.last
  end
end
