Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root "static_pages#top"

  resources :items do
    member do
      get :new_post # 断捨離ボタンを押した時の遷移先
    end
    collection do
      get :completed # 完了一覧表示用
    end
  end

  resources :posts, only: [:create, :show, :index, :edit, :update, :destroy]
  get 'my_posts', to: 'posts#my_posts' # 自分の投稿一覧表示用



  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end

