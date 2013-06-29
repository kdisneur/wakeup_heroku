class SyncingController < SignedInController
  def create
    heroku_api          = Heroku::API.new(api_key: current_user.api_token)
    heroku_applications = heroku_api.get_apps.body

    add_or_update_exising_applications(heroku_applications)
    remove_deleted_applications(heroku_applications)

    redirect_to signed_in_root_path
  end

private

  def add_or_update_exising_applications(heroku_applications)
    heroku_applications.each do |heroku_application|
      application      = current_user.applications.find_or_create_by(heroku_id: heroku_application['id'])
      application.name = heroku_application['name']
      application.url  = heroku_application['web_url']

      application.save
    end
  end

  def remove_deleted_applications(heroku_applications)
    heroku_application_ids = heroku_applications.map { |heroku_application| heroku_application['id'] }
    removable_applications = current_user.applications.reject { |application| heroku_application_ids.include?(application.heroku_id.to_i) }

    removable_applications.each(&:destroy)
  end
end
