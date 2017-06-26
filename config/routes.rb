Rails.application.routes.draw do

  resources :participants do 
    put  'user_nae'
    get  'user_agreement'
    put 'community_members'
  end  
  
  resources :lender_item_conditions do
      put 'lender_conditions'
      post 'update'
  end
  
  resources :lender_transfers do
    put 'lender_transfer'
    post 'update'
  end   
  resources :searches do
    put 'search_items'
  end  
 
  resources :contact_preferences do
    put 'user_contact_preferences'
   end
  
  resources :contact_describes
  
  resources :communities do
    get 'community_detail'
    post 'update'
  end  
  
  resources :items do
   post 'update'
   #put 'user_item'
  end
  
  resources :users do
    post 'update_user'
    post 'forgotUserName' 
    post 'forgotUserPassword'
    get  'user_login_update'
    get  'user_logout'
    get 'user_registration'
    get 'community_registration'
    
    
  end
  
  resources :home do
    get 'echomarket_instructions'
    get 'echomarket_agreement'
    get 'about'
  end
  
  resources :contacts 

  get  'sessions/new'
  post '/user_registration',  to: 'users#user_registration'
  get  '/activate/(:id)', to:  'users#activate_user'
  get  'users/show/(:id)', :controller => "users", :action => "show"
  post '/login',      to: 'users#user_login'
  get  '/echomarket', to: 'users#app_options'
  post 'users/activate/(:id)', to: 'users#activate'
  post 'participants/postUserAgreement'
  post 'participants/update'
  post 'participants/update_details', :controller => "participants", :action => "update_details"
  post 'participants/update_members', :controller => "participants", :action => "update_members"
  post 'contact_preferences/update'
  post 'lender_transfers/update'
  post 'lender_item_conditions/update'
  
  put  'items/show/(:id)', :controller => "items", :action => "show"
  get  'items/shout/(:id)', :controller => "items", :action => "shout"
  get  'items/borrowing_history/(:id)', :controller => "items", :action => "borrowing_history"
  put  'contacts/show', :controller => "contacts", :action => "show"
  post  'users/forgotUserPassword'
  post  'users/forgotUserName'
  post  'user/managePasswordChange'
  put   'searches/show/(:id)', :controller => "searches", :action => "show"
  post  'searches/update'
  get   'items/search_results/(:id)', :controller => "items", :action => "search_results"
  put   'lender_transfers/show/(:id)/(:name)', :controller => "lender_transfers", :action => "show"
  put   'lender_item_conditions/show/(:id)/(:name)', :controller => "lender_item_conditions", :action => "show"
  put   'contact_preferences/show/(:id)/(:name)', :controller => "contact_preferences", :action => "show"
  put   'participants/show/(:id)/(:name)', :controller => "participants", :action => "show"
  get   'participants/nae_readonly', :controller => "participants", :action => "nae_readonly"
  get   'items/existing_results/(:id)', :controller => "items", :action => "existing_results"
  get   'items/new_item/(:id)', :controller => "items", :action => "new_item"
  post  'items/(:id)', :controller => "items", :action => "update"   
  post   'items/update', :controller => "items", :action => "update"
  get   'communities/community_detail', :controller => "communities", :action => "community_detail"
  get   'participants/main_user_detail', :controller => 'participants', :action => 'main_user_detail'				    
  get   'participants/community_members', :controller => "participants", :action => "community_members"
  get   'users/user_logout', :controller => 'users', :action => 'user_logout'				    
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
