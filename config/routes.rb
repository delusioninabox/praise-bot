Rails.application.routes.draw do
  get '/' => 'home#index'

  namespace :api do
    resources :praise, defaults: {format: :json}
    resources :user, only: [:create], defaults: { format: :json}
  end
end
