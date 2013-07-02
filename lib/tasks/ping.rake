namespace :ping do
  desc 'Ping all activated Heroku apps'
  task all: :environment do
    User.where('applications.activated' => true).each do |user|
      user.applications.where(activated: true).each do |application|
        response              = Curl.get(application.url)
        application.last_ping = Time.now
        application.status    = (response.response_code.to_s =~ /([23][0-9]{2})|401/) ? 'up' : 'down'

        application.save
      end
    end
  end
end
