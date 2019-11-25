Rails.application.routes.draw do
  get '/' => 'home#index'

  namespace :api do
    resources :praise, defaults: {format: :json}
  end
end
