Rails.application.routes.draw do
  root('home#home')

  resources(:users, only: [:show, :new, :create, :edit, :update, :destroy]) do
    member do
      get(:address_edit)
      put(:address_update)
    end
  end
end
