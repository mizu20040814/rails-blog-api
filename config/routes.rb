Rails.application.routes.draw do
  # TODO: Check this API rootes
  resources :articles
  get "up" => "rails/health#show", as: :rails_health_check
end
