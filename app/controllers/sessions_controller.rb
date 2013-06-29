class SessionsController < ApplicationController
  def new
    redirect_to '/auth/heroku'
  end

  def create
    api_key = request.env['omniauth.auth']['credentials']['token']
    user    = create_or_update_user(api_key)

    session['current_user_id'] = user.id

    redirect_to signed_in_root_path
  end

  def destroy
    session['current_user_id'] = nil if params[:id].to_s == session['current_user_id'].to_s
    redirect_to root_path
  end

private

  def create_or_update_user(api_key)
    heroku_api     = Heroku::API.new(api_key: api_key)
    heroku_user    = heroku_api.get_user.body

    user           = User.find_or_create_by(heroku_id: heroku_user['id'])
    user.api_token = api_key
    user.email     = heroku_user['email']
    create_heroku_applications(heroku_api) unless user.applications.present?
    user.save

    user
  end

  def create_heroku_applications(heroku_api)
    applications = heroku_api.get_apps.body
    applications.each do |application|
      user.applications << Application.new(heroku_id: application['id'], name: application['name'], url: application['web_url'])
    end
  end
end
