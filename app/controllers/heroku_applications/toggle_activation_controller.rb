module HerokuApplications
  class ToggleActivationController < SignedInController
    def create
      application           = current_user.applications.where(heroku_id: params[:heroku_application_id]).first
      application.activated = !application.activated

      if application.save
        analytic_event = application.activated ? 'Activate' : 'Deactivate'
        analytical.event("#{analytic_event} application", id: current_user.heroku_id, application_id: application.heroku_id)
      end

      redirect_to signed_in_root_path
    end
  end
end
