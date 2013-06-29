class HerokuApplicationsController < SignedInController
  expose(:applications) { current_user.applications }
end
