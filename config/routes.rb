WakeupHeroku::Application.routes.draw do
  scope constraints: ->(request) { request.session['current_user_id'].present? } do
    resources :heroku_applications do
      resource :toggle_activation, only: [:create], controller: 'heroku_applications/toggle_activation'
    end
    resource :syncing, only: [:create], controller: 'syncing'

    root 'heroku_applications#index', as: 'signed_in_root'
  end

  get '/auth/:provider/callback' => 'sessions#create'

  resources :sessions, only: [:new, :destroy]

  root 'welcome#index'
end
