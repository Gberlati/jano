Rails.application.routes.draw do
  root 'pages#home'
  
  match '/products/create_bulk', to: 'products#create_bulk', via: [:get, :post]

  resources :products

  

end
