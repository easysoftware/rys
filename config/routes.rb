Rails.application.routes.draw do

  namespace :easy do
    get 'features', to: 'features#index'
  end

end
