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
    analytical.event('Signout', id: current_user.heroku_id)

    session['current_user_id'] = nil if params[:id].to_s == session['current_user_id'].to_s
    redirect_to root_path
  end

private

  def create_or_update_user(api_key)
    heroku_api     = Heroku::API.new(api_key: api_key)
    heroku_user    = heroku_api.get_user.body

    user           = User.find_or_initialize_by(heroku_id: heroku_user['id'])
    user.api_token = api_key
    user.email     = heroku_user['email']

    analytic_event = user.new_record? ? 'Signup' : 'Signin'
    analytical.event(analytic_event, id: user.heroku_id)

    create_heroku_applications(user, heroku_api) unless user.applications.present?

    user.save

    user
  end

  def create_heroku_applications(user, heroku_api)
    applications = heroku_api.get_apps.body
    applications.each do |application|
      application = Application.new(heroku_id: application['id'], name: application['name'], url: application['web_url'])
      analytical.event('Add application', id: user.heroku_id, application_id: application.heroku_id, application_name: application.name)

      user.applications << appliaction
    end
  end
end
