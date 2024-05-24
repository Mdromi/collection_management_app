class ApplicationController < ActionController::Base
  include Devise::Controllers::Helpers
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale

  protected

  def configure_permitted_parameters 
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :profile_image])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :profile_image])
  end

  private

  def set_locale
    I18n.locale = extract_locale_from_cookie || I18n.default_locale
    puts "I18n.locale #{I18n.locale}"
  end

  def extract_locale_from_cookie
    cookies[:locale] if I18n.available_locales.map(&:to_s).include?(cookies[:locale])
  end
end
