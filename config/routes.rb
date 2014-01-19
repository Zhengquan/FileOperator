Picturesque::Application.routes.draw do
  root :to => "galleries#index"

  resources :galleries
  resources :paintings
  get 'paintings/:id/download', to: 'paintings#download', as: 'download_painting'
end
