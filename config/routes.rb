Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  post "/marklogic/documents", to: "marklogic#put_document"
  get  "/marklogic/documents", to: "marklogic#get_document"
  post "/marklogic/xquery",   to: "marklogic#eval_xquery"

  namespace :admin do
    resources :mcp_types, only: [ :index, :show ]
  end
end
