Rails.application.routes.draw do
  root 'home#index'

  resources :promotions do
    post 'generate_coupons', on: :member
  end

  resources :product_categories, only: [:index, :show, :new, :create, :edit, :update]
end
