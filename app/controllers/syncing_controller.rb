class SyncingController < SignedInController
  def create
    heroku_api          = Heroku::API.new(api_key: current_user.api_token)
    heroku_applications = heroku_api.get_apps.body

    add_or_update_exising_applications(heroku_applications)
    remove_deleted_applications(heroku_applications)

    analytical.event('Sync applications', id: current_user.heroku_id)

    redirect_to signed_in_root_path
  end

private

  def add_or_update_exising_applications(heroku_applications)
    heroku_applications.each do |heroku_application|
      application      = current_user.applications.find_or_create_by(heroku_id: heroku_application['id'])
      application.name = heroku_application['name']
      application.url  = heroku_application['web_url']

      analytical.event('Add application', id: current_user.heroku_id, application_id: application.heroku_id, application_name: application.name)

      application.save
    end
  end

  def remove_deleted_applications(heroku_applications)
    heroku_application_ids = heroku_applications.map { |heroku_application| heroku_application['id'] }
    removable_applications = current_user.applications.reject { |application| heroku_application_ids.include?(application.heroku_id.to_i) }

    removable_applications.each do |application|
      analytical.event('Remove application', id: current_user.heroku_id, application_id: application.heroku_id, application_name: application.name)

      application.destroy
    end
  end
end
