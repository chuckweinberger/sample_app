SampleApp::Application.routes.draw do

	resources :users do
		member do
			get :following, :followers
		end
		resources :microposts, :only => [:index]
	end
	resources :microposts, :only => [:create, :destroy]
	resources :sessions, :only => [:new, :create, :destroy]
	resources :relationships, :only => [:create, :destroy]

	root :to => 'pages#home'
	
	match '/signup',	:to => 'users#new'
	match '/signin',	:to => 'sessions#new'
	match '/signout',	:to => 'sessions#destroy'
	match '/contact', 	:to => 'pages#contact'
	match '/about',   	:to => 'pages#about'
	match '/help',    	:to => 'pages#help'
  

end

