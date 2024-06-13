# config/initializers/omniauth.rb

# Load the Google OAuth2 client ID and client secret from the environment variables
google_oauth_client_id = ENV["GOOGLE_OAUTH_CLIENT_ID"]
google_oauth_client_secret = ENV["GOOGLE_OAUTH_CLIENT_SECRET"]


# Configure OmniAuth with the obtained values
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, google_oauth_client_id, google_oauth_client_secret
end
