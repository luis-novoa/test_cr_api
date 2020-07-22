Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resources :customers, only: [:create, :index]
  end
end
