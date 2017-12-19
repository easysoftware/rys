Rails.application.routes.draw do

  get 'easy_features', to: 'easy_features#index', as: 'easy_features'
  post 'easy_features/:id/update', to: 'easy_features#update', as: 'update_easy_feature'

end
