class UsersController < ApplicationController
  # Loads a user's page
  get '/users/:slug' do
    if logged_in?
      @user = User.find_by_slug(params[:slug])
      erb :"users/show"
    else
      redirect to '/login'
    end
  end

  # Loads the create_user page, which contains a form to create a new user
  get '/signup' do
    # If a user is already logged in, then they cannot sign up, so they'll be redirected to their page
    if logged_in?
      redirect to "/users/#{current_user.slug}"
    else
      erb :"users/create_user"
    end
  end

  # Gets the input from the form and creates a new user
  post '/signup' do
    # If the user did not enter a username and password then they have to fill out the form again
    if params[:username] == "" || params[:password] == ""
      redirect to '/signup'
    else  # Otherwise a new user is created with the info and the user is then redirected to their page
      @user = User.create(username: params[:username], password: params[:password])
      session[:user_id] = @user.id
      redirect to "/users/#{current_user.slug}"
    end
  end

  # Loads the login page, which contains a form used to login
  get '/login' do
    # If a user is already logged in, then they cannot log in again, so they'll be redirected to thir page
    if logged_in?
      redirect to "/users/#{current_user.slug}"
    else
      erb :"users/login"
    end
  end

  # Get's the input from the form and logs in the user as long as a user is found with the given username
  # and that user has a matching password
  post '/login' do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect to "/users/#{current_user.slug}"
    else
      redirect to '/login'
    end
  end

  # If a user is already logged in then they are able to logout
  get '/logout' do
    if logged_in?
      session.destroy
      redirect to '/login'
    else
      redirect to '/'
    end
  end
end