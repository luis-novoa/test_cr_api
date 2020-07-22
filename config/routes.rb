Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resources :customers, only: %i[create index destroy]
    resources :medicines, except: %i[new edit]
    resources :carts, only: %i[create index destroy]
  end
end
