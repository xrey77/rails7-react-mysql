Rails.application.routes.draw do
  resources :products

  root 'home#index'

  namespace :api do
    resources :users
    resources :users, only: [:REGISTER, :LOGIN, :GETUSERBYID, :GETALLUSERS, :UPDATEUSERPROFILE, :UPDATEUSERPICTURE, :ACTIVATEMFA]
    post '/signin', to: 'users#LOGIN'
    post '/signup', to: 'users#REGISTER'  
    get '/getuserbyid/:id', to: 'users#GETUSERBYID'
    get '/getallusers', to: 'users#GETALLUSERS'
    put '/updateprofile/:id', to: 'users#UPDATEUSERPROFILE'
    put '/updateuserpicture/:id', to: 'users#UPDATEUSERPICTURE'
    put '/activateotp/:id', to: 'users#ACTIVATEMFA'
    post '/validateotpcode', to: 'users#VALIDATETOKEN'
    get '/getallproducts/:page', to: 'products#PRODUCTLIST'
    get '/getproductdetails/:page', to: 'products#PRODUCTDETAILS'    
  end

end
