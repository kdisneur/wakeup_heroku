set :output, 'log/wheneverer.log'

every 5.minutes do
  rake 'ping:all'
end
