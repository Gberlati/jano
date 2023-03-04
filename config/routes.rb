Rails.application.routes.draw do
  root 'pages#home'
  get '/product/create', to: 'product#create'
end
