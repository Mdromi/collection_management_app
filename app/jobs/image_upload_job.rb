require 'net/http'
require 'uri'
require 'json'

class ImageUploadJob < ApplicationJob
  queue_as :default

  def perform(record_class, record_id, attribute_name, encoded_image)
    record = record_class.constantize.find(record_id)

    imgbb_response = upload_image_to_imgbb(encoded_image)
    if imgbb_response && imgbb_response["data"] && imgbb_response["data"]["url"]
      record.update(attribute_name => imgbb_response["data"]["url"])
      if record.save
        Rails.logger.info "Image updated successfully for #{record_class} #{record.id}"
      else
        Rails.logger.error "Failed to save image for #{record_class} #{record.id}: #{record.errors.full_messages.to_sentence}"
      end
    else
      Rails.logger.error "Failed to upload image for #{record_class} #{record.id}"
    end
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
