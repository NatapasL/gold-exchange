Rails.application.routes.draw do
  root to: 'admin/transactions#index'

  devise_for :users, skip: [:registrations], controllers:{ sessions: 'users/sessions'}

  use_doorkeeper scope: 'api' do
    skip_controllers :applications, :authorized_applications
  end

  scope module: :api, defaults: { format: :json }, path: 'api' do
    devise_for :users,
      path: '',
      path_names: {
        registration: 'register'
      },
      controllers: {
        registrations: 'api/users/registrations',
      },
      skip: [:sessions, :passwords]

    resources :balances, only: [:index]

    resources :transactions, only: [:index] do
      post :buy, on: :collection
      post :sell, on: :collection
      post :top_up, on: :collection
      post :withdraw, on: :collection
    end
  end

  namespace :admin, path: 'admin' do
    resources :transactions, only: [:index] do
      patch :approve, on: :member
      patch :reject, on: :member
    end
  end
end
