Rails.application.routes.draw do
  resources :books
  root 'books#index'
  get '/books', to: redirect('/') 
  get '/addbook', to: 'books#new'
  post '/addbook', to: 'books#create'
  get '/show/:title', to: 'books#show', as: 'show_book'
  #get '/edit/:title', to: 'books#edit', as: 'edit_book'
  patch '/edit/:title', to: 'books#update'
  delete '/remove/:title', to: 'books#destroy', as: 'remove_book'
  get '/remove/:title', to: 'books#destroy'
  get '/remove/:title/confirm', to: 'books#delete', as: 'confirm_remove_book'

end