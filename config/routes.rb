Rails.application.routes.draw do
  devise_for :users, skip: [:registrations]

  namespace :admin do
    root "dashboard#index"

    resources :inscricoes, only: [ :index, :edit, :update, :destroy ]
    resources :sociedades

    resources :modalidades, only: [ :index, :show ] do
      resources :equipes, module: :modalidades do
        resources :membro_equipes, only: [ :create, :destroy ], module: :equipes
      end
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  get "home", to: "home#index"
  get "roteiro_orar", to: "home#roteiro_orar"
  get "inscricoes", to: "home#inscricoes"
  post "inscricoes", to: "home#create_inscricao"
  get "footer", to: "home#footer"
  root "home#index"
end
