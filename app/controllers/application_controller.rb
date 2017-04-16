class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_current_reader

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_reader!

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :second_name, :nick, :gender])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :second_name, :gender, :birthdate, :avatar])
  end

  def administrative_rights
    unless current_reader.admin?
      redirect_to root_url, notice: "Access restricted"
    end
  end

  # Make current_reader accesible from models
  def set_current_reader
    Reader.current = current_reader
  end
end
