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
    post(:oauth, on: :collection)
  end
  resources(:password_resets, only: [:new, :create, :edit, :update])
  resources(:todos, only: [:index, :show]) do
    member do
      put(:ship)
      put(:receive)
    end
  end
  resources(:products) do
    collection do
      get(:search)
      get(:purchace_index)
    end
    put(:purchace, on: :member)
    resources(:evaluations, only: [:new, :create])
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
        get(:solded_index)
      end
      get(:image, on: :member)
    end

    resources(:purchace_products, only: [:index]) do
      get(:received_index, on: :collection)
    end
  end
end
