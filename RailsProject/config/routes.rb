Rails.application.routes.draw do

  #
  # API ROUTES (57 / 57)
  #
  namespace :api, path: '/', constraints: { subdomain: 'api' }, :defaults => { :format => 'json' }  do
    get 'getKey/:id' => 'apisecurity#provideKey', constraints: {id: /[0-9]+/}

    resources :albums, only: [:index, :show] do #ok
      collection do
        get 'find' => 'albums#find'
        get 'addcomment/:id' => 'albums#addcomment', constraints: {id: /[0-9]+/}
      end
    end

    resources :battles, only: [:index, :show] do #ok
      collection do
        get 'find' => 'battles#find'
      end
    end

    get 'carts/find' => 'carts#find'
    post 'carts/save' => 'carts#save'
    get 'carts/destroy' => 'carts#destroy' #ok

    resources :concerts, only: [:index, :show] do #ok
      collection do
        get 'find' => 'concerts#find'
      end
    end

    post 'gifts/save' => 'gifts#save' #ok

    resources :listenings, only: [:index, :show] do #ok
      collection do
        get 'find' => 'listenings#find'
        post 'save' => 'listenings#save'
      end
    end

    resources :messages, only: [:show] do #ok
      collection do
        get 'find' => 'messages#find'
        post 'save' => 'messagess#save'
      end
    end

    resources :musics, only: [:index, :show] do #ok
      collection do
        get 'find' => 'musics#find'
        post 'addcomment/:id' => 'musics#addcomment', constraints: {id: /[0-9]+/}
        get 'get/:id' => 'musics#get', constraints: {id: /[0-9]+/}, format: 'mp3' #verifier si ça fonctionne
        post 'addtoplaylist' => 'musics#addtoplaylist'
      end
    end

    resources :news, only: [:index, :show] do #ok
      collection do
        get 'find' => 'news#find'
        post 'addcomment/:id' => 'news#addcomment', constraints: {id: /[0-9]+/}
      end
    end

    resources :notifications, only: [:show] do #ok
      collection do
        post 'save' => 'notifications#save'
        get 'find' => 'notifications#find'
        get 'destroy' => 'notifications#destroy'
      end
    end

    resources :packs, only: [:index, :show] do #ok
      collection do
        get 'find' => 'packs#find'
      end
    end

    resources :playlists, only: [:show] do #ok
      collection do
        get 'find' => 'playlists#find'
        post 'save' => 'playlists#save'
        post 'update' => 'playlists#update'
        get 'destroy' => 'playlists#destroy'
      end
    end

    post 'purchases/save' => 'purchases#save' #ok
    get 'search' => 'searchs#search' #ok
    get 'suggest' => 'suggestions#show' #ok

    resources :tweets, only: [:index, :show] do #ok
      collection do
        get 'find' => 'tweets#find'
        post 'save' => 'tweets#save'
        get 'destroy' => 'tweets#destroy'
      end
    end

    resources :users, only: [:index, :show] do #ok
      collection do
        get 'find' => 'users#find'
        post 'save' => 'users#save'
        post 'update' => 'users#update'
        get 'getmusics' => 'users#getmusics'
      end
    end
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
