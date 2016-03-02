Rails.application.routes.draw do
  root 'pages#index'

  get '/placer', to: 'placer#show'
  get '/auth/google_oauth2/callback', to: "sessions#create"
end
