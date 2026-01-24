VectorMCP::Admin::Engine.routes.draw do
  root to: "tools#index"
  resources :tools, only: [ :index, :show ] do
    post :execute, on: :member
  end
end
