class ErrorsController < ApplicationController
  def not_found
    render 'errors/404', status: :not_found, layout: 'application'
  end
end
