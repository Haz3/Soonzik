Rails.application.routes.draw do

  namespace :api, path: '/', constraints: { subdomain: 'api' }, :defaults => { :format => 'json' }  do
    get 'getKey/:id' => 'apisecurity#provideKey', constraints: {id: /[0-9]+/}

    resources :albums, only: [:index] do
      collection do
        get 'addcomment/:id' => 'albums#addcomment', constraints: {id: /[0-9]+/}
      end
    end



    #get ':modelName/:actionName(/:id)' => 'apisecurity#action', :defaults => { :format => 'json' }
    #get ':modelName/:actionName(/:start/:length)' => 'apisecurity#action', :defaults => { :format => 'json' }, constraints: {start: /[0-9]+/, length: /[0-9]+/}
  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :users

  resources :votes

  resources :tweets

  resources :tags

  resources :purchases

  resources :propositions

  resources :playlists

  resources :packs

  resources :notifications

  resources :newstexts

  resources :news

  resources :music_notes

  resources :musics

  resources :messages

  resources :listenings

  resources :influences

  resources :groups

  resources :gifts

  resources :flacs

  resources :genres

  resources :descriptions

  resources :concerts

  resources :commentaries

  resources :carts

  resources :battles

  resources :attachments

  resources :album_notes

  resources :albums

  resources :addresses

  resources :accesses

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
