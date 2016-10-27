Widget::Application.routes.draw do

  scope "api" do
    resources :listings do
      post :update_clicked_phone_number, :on => :member
      post :update_reserved_number, :on => :member
      resources :improve_listings, :only => ['create']
    end
    resources :ads
    resources :suggestions do
        get 'cities', :on => :collection
    end
    resource :geocoder, only: [] do
      post :city_and_state
    end

    get 'offer/show/' => "offers#show", :constraints => lambda {|req| req.params[:what] || req.params[:where] }
    put 'offer/set_clicked_time/:id' => "offers#set_clicked_time"
    put 'offer/set_closed_window_time/:id' => "offers#set_closed_window_time"
    get 'offer/latest_num_match/:num_type' => "offers#latest_num_match"
  end


  match 'cookie_test' => 'application#cookie_test', :as => :cookie_test

  root :to  => "widget#index"

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
  # match ':controller(/:action(/:id))(.:format)'
end
