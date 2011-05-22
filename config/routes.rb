Importrequire::Application.routes.draw do

	resources :User 
	match "register" => "User#create", :as => "register"
	match "logout" => "welcome#logout", :as => "logout"
	match "login" => "welcome#login", :as => "login"
	match "search" => "search#search", :as => "search"
	match "help" => "help#help", :as => "help"
  match "inbox" => "message#inbox", :as =>"inbox"
  match "inbox/compose" => "message#compose", :as =>"compose"
  match "inbox/compose/:handle" => "message#compose", :as =>"compose_to"
  match "inbox/create_mail" => "message#create_mail", :as =>"create_mail"
  match "inbox/:mid" => "message#view", :as =>"view_mail"
  match "inbox/:mid/reply" => "message#reply", :as =>"reply_mail"
  match "inbox/:mid/unread" => "message#unread", :as =>"unread_mail"
  match "inbox/:mid/delete" => "message#delete", :as =>"delete_mail"
	match ":handle/works/:wid/rate/:rating" => "User#rate_work", :as => "user_rate_work"
	match ":handle/works/create_work" => "User#create_work", :as => "user_create_work"
	match ":handle/works/remove_work/:wid" => "User#remove_work", :as => "user_remove_work"
	match ":handle/works/edit_work/:wid" => "User#edit_work", :as => "user_edit_work"
	match ":handle/works" => "User#works", :as => "user_works"
	match ":handle/edit/create_affil" => "User#create_affil", :as => "user_create_affil"
	match ":handle/edit/remove_affil/:name" => "User#remove_affil", :as => "user_remove_affil"
	match ":handle/edit/create_tag" => "User#create_tag", :as => "user_create_tag"
	match ":handle/edit/remove_tag/:id" => "User#remove_tag", :as => "user_remove_tag"
	match ":handle/edit/remove_all_tags" => "User#remove_all_tags", :as => "user_remove_all_tags"
	match ":handle/tags" => "User#edit_tags", :as => "user_tags"
	match ":handle/edit" => "User#edit", :as => "user_edit"
	match ":handle" => "User#view", :as => "user_name"

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
   root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
