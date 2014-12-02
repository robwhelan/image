ImageLook::Application.routes.draw do

  resources :phones
  resources :emails
  resources :comments

  root :to => "pages#status"
  get "pages/synthesize_contacts"
  get "products/show_products"
  get "pages/build_contact"
  get "pages/get_touchpoints"
  get "pages/status"
  get "pages/update_gmail"
  get "pages/update_linked_in"
  get "pages/update_cell_data"
  get "pages/update_all"
  get "pages/setup_connections"
  get "pages/save_vault"
  get "pages/update_data"
  get "pages/about"
  get "pages/add_tags"
  get "pages/vault_password"
  get "pages/add_comment"
  get "pages/upload_vcard"
  post "pages/upload"
  get "pages/get_google_contacts"
  
  resources :touchpoints
  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }

  resources :contacts do
    member do
      get :toggle_contact_as_actionable
      post :create_contact_from_vcard
    end
  end
  resources :text_verizons
  resources :linked_in_messages
  resources :linked_in_invitations
  resources :call_verizons
  resources :email_gmails
  resources :new_comms
  
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
