class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_user
    if (user_id = session['current_user_id'])
      @current_user ||= User.where(id: user_id).first
    end
  end
  helper_method :current_user
end
