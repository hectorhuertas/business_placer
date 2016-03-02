Rails.application.routes.draw do
  root 'placer#show'

  get '/login',                       to: "sessions#new"
  get '/logout',                      to: "sessions#destroy"
  get '/auth/google_oauth2/callback', to: "sessions#create"



  get '/jsoner', to: "placer#jsoner"
end
