# app/lib/image_uploadable.rb

require "net/http"
require "uri"
require "json"

module ImageUploadable
  def upload_image_to_imgbb(image_data)
    url = URI.parse("https://api.imgbb.com/1/upload")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    puts "Env #{ENV["IMGBB_API_KEY"]}"

    request = Net::HTTP::Post.new(url)
    request.set_form_data({
      "key" => ENV["IMGBB_API_KEY"],
      "image" => image_data,
    })

    response = http.request(request)
    puts "Response body: #{response.body}"
    parsed_response = JSON.parse(response.body)
    puts "Parsed response: #{parsed_response}"
    parsed_response # return the parsed response
  end
end
