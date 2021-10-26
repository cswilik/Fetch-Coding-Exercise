Rails.application.routes.draw do
  root 'transactions#index'
  post '/transactions', to: 'transactions#create' 
  post '/spend-points', to: 'transactions#spend'
end
