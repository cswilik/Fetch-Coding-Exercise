Rails.application.routes.draw do
  root 'transactions#index'
  post '/transactions', to: 'transactions#create' 
  post '/spend-points', to: 'transactions#spend'
  get '/points-balance', to: 'transactions#balance'
end
