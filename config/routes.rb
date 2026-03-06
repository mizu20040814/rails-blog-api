Rails.application.routes.draw do
  # TODO: Check this API rootes
  namespace :api do
    namespace :v1 do
      # Auth
      post "auth/login", to: "auth#login"

      # *user_auth :new!
      post 'users/register', to: 'users#register'
      post 'users/login', to: 'users#login'

      # 公開URL
      # TODO: Comments処理を追加する
      resources :articles, only: [ :index, :show ] do
        resources :comments, only: [ :index, :create ]
      end
      resources :comments, only: [ :destroy ]

      # 認証後のURL
      namespace :admin do
        resources :articles
      end
    end
  end
  get "up" => "rails/health#show", as: :rails_health_check
end
