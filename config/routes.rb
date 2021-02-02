Rails.application.routes.draw do
  root('home#home')
  get('/log_in', to: 'sessions#new')
  post('/log_in', to: 'sessions#create')
  delete('/log_out', to: 'sessions#destroy')
  get('/account_activate', to: 'account_activations#edit')
  get('/oauth/authorization', to: 'oauth#authorization')
  get('/oauth/callback', to: 'oauth#callback')

  resources(:users, only: [:show, :new, :create, :edit, :update, :destroy]) do
    member do
      get(:edit_address)
      put(:update_address)
    end
    collection do
      post('oauth')
    end
  end
  resources(:password_resets, only: [:new, :create, :edit, :update])
  resources(:purchaced_products, only: [:index, :show]) do
    member do
      put(:ship)
      put(:receive)
    end
    resources(:evaluations, only: [:new, :create])
  end
  resources(:products) do
    collection do
      get(:search)
    end
    resources(:purchaced_products, only: [:create])
  end
  resources(:messages, only: [:create, :destroy])
  resources(:notices, only: [:index])
  resources(:likes, only: [:index])
  namespace(:api) do
    resources(:products, only: [:index]) do
      resources(:likes, only: [:create])
      resource(:like, only: [:destroy])
      collection do
        get(:traded_index)
      end
      member do
        get(:image)
      end
    end
  end
end
