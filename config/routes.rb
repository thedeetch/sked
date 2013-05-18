Sked::Application.routes.draw do
  get "home/index"
  
  match "/shifts/(:department_id)/(:date)" => 'shift#index', :as => :shift
  match "employees/time_off" => 'time_off#index', :as => :time_off

  resources :shift do
    get 'resources/:department_id/(:date)' => 'shift#resources', on: :collection
    get ':department_id/(:date)' => 'shift#index', on: :collection
  end

  resources :employees do
    get 'time_off/(:date)' => 'time_off#show', :as => :time_off
    post 'time_off' => 'time_off#create'
    put 'time_off/:id' => 'time_off#update'
    delete 'time_off/:id' => 'time_off#delete'
    get 'hours/:date' => 'employees#hours_for_week'
  end
  
  resources :departments do
    put 'employee' => 'departments#add_employee', :as => :employee_add
    delete 'employee/:employee_id' => 'departments#remove_employee', :as => :employee_remove
  end

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
  root :to => 'home#index'

# See how all your routes lay out with "rake routes"

# This is a legacy wild controller route that's not recommended for RESTful applications.
# Note: This route will make all actions in every controller accessible via GET requests.
# match ':controller(/:action(/:id))(.:format)'
end
