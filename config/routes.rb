Rails.application.routes.draw do
  root 'placer#show'

  get '/login',                       to: "sessions#new"
  get '/logout',                      to: "sessions#destroy"
  get '/auth/google_oauth2/callback', to: "sessions#create"

  namespace :api , defaults: {format: :json} do
    namespace :v1 do
      namespace :analyst do
        get "/city", to: "city#index"
        get "/heatmap", to: "heatmap#show"
      end

      get '/checker', to: 'checker#show'

      namespace :search do
        get '/simple', to: "simple#index"
      end
    end
  end
end
