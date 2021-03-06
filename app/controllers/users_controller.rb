class UsersController < ApplicationController
  
	before_filter :authenticate, 	:except => [:show, :new, :create]
	before_filter :correct_user, 	:only => [:edit, :update]
	before_filter :admin_user, 		:only => :destroy
#	after_filter  :set_admin,		:only => :new
  
  	
	def index
		@title = "All users"
		@users = User.paginate(:page => params[:page])
	end
	
	def show
		@user = User.find(params[:id])
		@microposts = @user.microposts.paginate(:page => params[:page])
		@title = @user.name
	end

	def new
		if !signed_in?
			@title = "Sign up"
			@user = User.new
		else
			redirect_to root_path
		 end	
	end

	def create
		if !signed_in?
			@user = User.new(params[:user])
			if @user.save
				sign_in @user
				flash[:success] = "Welcome to the Sample App!"
				set_admin @user
				redirect_to @user
			else
				@title = "Sign up"
				@user.password = ""
				@user.password_confirmation = ""
				render 'new'
			end
		else
			redirect_to root_path
		end
	end
 
	def edit
		@title = "Edit user"
	end

    def update
		@user = User.find(params[:id])
		if @user.update_attributes(params[:user])
			flash[:success] = "Profile updated."
			redirect_to @user
		else
			@title = "Edit user"
			render 'edit'
		end
	end

	def destroy
		delete_user = User.find(params[:id])
		if !delete_user.admin?
			delete_user.destroy
			flash[:success] = "User destroyed"
			redirect_to users_path
		else
			flash[:error] = "You can't destroy an admin user"
			redirect_to users_path
		end
	end	
			
	def following
		@title = "Following"
		@user = User.find(params[:id])
		@users = @user.following.paginate(:page => params[:page])
		render 'show_follow'
	end

	def followers
		@title = "Followers"
		@user = User.find(params[:id])
		@users = @user.followers.paginate(:page => params[:page])
		render 'show_follow'
	end
  
	private
		
		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_path) unless current_user?(@user)
		end

		def	admin_user
			redirect_to(root_path) unless current_user.admin?
		end
		
		def set_admin(user)
			reg = /\A[\w+-.]+\@ADMIN.USER\z/
			if !reg.match(user.email).nil?
				user.toggle!(:admin)
			end
		end
		
end
