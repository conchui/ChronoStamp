ChronoStamp::Application.routes.draw do

  resources :users
    get "sign_up" => "users#new", :as => "sign_up"
    get "password_reset" => "users#edit", :as => "password_reset"
    get "manage_users" => "users#manage", :as => "manage_users"
    get "track_user/:id" => "users#track_user", :as => "track_user"
    get "edit_users/:id" => "users#edit_users", :as => "edit_users"
    patch "edit_users/:id" => "users#update_users"
    get "time_tracker" => "users#time_tracker", :as => "time_tracker"
    post "time_stamp" => "users#time_stamp"
    
  resources :sessions
    get "log_out" => "sessions#destroy", :as => "log_out"
    get "log_in" => "sessions#new", :as => "log_in"

  resources :projects
    get "project/:id" => "projects#makers", :as => "makers"
    post "project/add_makers" => "projects#add_makers", :as => "add_makers"
  
  resources :tasks
    get "project/:id/task/:id" => "tasks#assign", :as => "assign"
    post "task/assign" => "tasks#add_assign", :as => "add_assign"
    post "task/time/:id" => "tasks#time", :as => "task_time"

  get '*path' => redirect('/')
  root :to => "users#index"

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
