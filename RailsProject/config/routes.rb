Rails.application.routes.draw do

  root 'others#index'

  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup

  #
  # API ROUTES
  #
  namespace :api, path: '/', constraints: { subdomain: 'api' }, :defaults => { :format => 'json' }  do
    get 'getKey/:id' => 'apisecurity#provideKey', constraints: {id: /[0-9]+/}
    get 'getSocialToken/:uid/:provider' => 'apisecurity#getSocialToken'
    post 'social-login' => 'apisecurity#socialLogin'
    post 'login' => 'apisecurity#login'
    post 'loginFB/:token' => 'apisecurity#loginFB'

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

    resources :genres, only: [:index, :show] do #ok
    end

    post 'gifts/save' => 'gifts#save' #ok

    resources :influences, only: [:index] do #ok
    end

    resources :listenings, only: [:index, :show] do #ok
      collection do
        get 'find' => 'listenings#find'
        post 'save' => 'listenings#save'
      end
    end

    resources :messages, only: [:show] do #ok
      collection do
        get 'find' => 'messages#find'
        post 'save' => 'messages#save'
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

  resources :accesses
  resources :addresses
  resources :albums
  resources :album_notes
  resources :attachments
  resources :battles
  resources :carts
  resources :commentaries
  resources :concerts
  resources :descriptions
  resources :flacs
  resources :genres
  resources :gifts
  resources :groups
  resources :influences
  resources :listenings
  #resources :messages
  resources :musics
  resources :music_notes
  resources :news
  resources :newstexts
  resources :notifications
  resources :packs
  resources :playlists
  resources :propositions
  resources :purchases
  resources :tags
  resources :tweets
  resources :users
  resources :votes

  get 'messages' => 'chats#index'


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
