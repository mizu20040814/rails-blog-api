Rails.application.routes.draw do
  # TODO: Check this API rootes
  namespace :api do
    namespace :v1 do
      # Auth
      post "auth/login", to: "auth#login"

      # 公開URL
      resources :articles, only: [ :index, :show ]

      # 認証後のURL
      namespace :admin do
        resources :articles
      end
    end
  end
  get "up" => "rails/health#show", as: :rails_health_check
end
