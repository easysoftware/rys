Rails.application.routes.draw do

  get 'rys_features', to: 'rys_features#index', as: 'rys_features'
  post 'rys_features/:id/update', to: 'rys_features#update', as: 'update_rys_feature'

end
