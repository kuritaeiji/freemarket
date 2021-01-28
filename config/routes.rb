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
  resources(:products) do
    collection do
      get(:search)
    end
  end
  namespace(:api) do
    resources(:products, only: [:index]) do
      collection do
        get(:traded_index)
      end
      member do
        get(:image)
      end
    end
  end
end
