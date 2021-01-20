Rails.application.routes.draw do
  root('home#home')

  resources(:users, only: [:show, :new, :create, :edit, :update, :destroy]) do
    member do
      get(:address_edit)
      put(:address_update)
    end
  end

  get('/log_in', to: 'sessions#new')
  post('/log_in', to: 'sessions#create')
  delete('/log_out', to: 'sessions#destroy')
  get('/account_activate', to: 'account_activations#edit')
end
