class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end

  def in_the_future?(event)
    event.datetime > Date.current.to_formatted_s(:db)
  end
  helper_method :in_the_future? # Gives method access to view
end
