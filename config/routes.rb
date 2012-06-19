LitSocial::Application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)

  post "convert/word_doc" => 'convert#word_doc', :as => :convert_word_doc
  
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :stories
  resources :categories, only: [:index, :show]
  resources :series, only: [:index, :show]
  resources :comments, only: [:create, :update, :destroy]
  resources :accounts, only: [:index, :show, :edit, :update] do
    resources :messages do
      collection do
        get :read
        get :sent
      end
    end
    member do
      get :stories
    end
  end
  
  resources :news_posts, only: [:index, :show], path: "site_news"
  get "pages" => 'pages#index', as: :pages
  get "pages/*id" => 'pages#show', as: :page
  
  resources :watches, only: [:create, :destroy]
  
  resources :users, only: [:show] do
    member do
      get :series
      get :stories
    end
  end

  get 'errors/403' => 'home#four_oh_three'
  get 'errors/404' => 'home#four_oh_four'
  root :to => 'home#index'
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
