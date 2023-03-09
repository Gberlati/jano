Rails.application.routes.draw do
  root 'pages#home'
  
  match '/products/create_bulk', to: 'products#create_bulk', via: [:get, :post]
  match '/products/create_bulk_update_list', to: 'products#create_bulk_update_list', via: [:get, :post]

  resources :products

  

end
