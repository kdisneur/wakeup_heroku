module HerokuApplications
  class ToggleActivationController < SignedInController
    def create
      application           = current_user.applications.where(heroku_id: params[:heroku_application_id]).first
      application.activated = !application.activated
      application.save

      redirect_to signed_in_root_path
    end
  end
end
