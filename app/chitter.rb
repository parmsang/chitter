require 'sinatra/base'
require_relative "../data_mapper_setup"
require_relative "./models/user"
require_relative "./models/peep"
require_relative "./models/comment"
require 'sinatra/session'
require 'sinatra/flash'

class Chitter < Sinatra::Base

  enable :sessions
  set :session_secret, 'super secret'
  register Sinatra::Flash
  use Rack::MethodOverride

  get '/' do
    @user = User.new
    erb :index
  end

  get '/users/new' do

    @user = User.new
    erb :'users/new'
  end

  post '/users' do
    @user = User.new(email: params[:email],
                     password:     params[:password],
                     first_name:   params[:first_name],
                     last_name:    params[:last_name],
                     username:     params[:username])
    if @user.save
      session[:user_id] = @user.id
      redirect to('/peeps')
    else
      flash.now[:errors] = @user.errors.full_messages
      erb :'users/new'
    end
  end

  helpers do
    def current_user
      User.get(session[:user_id])
    end
  end

  get '/sessions/new' do
    erb :'sessions/new'
  end

  post '/sessions' do
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      redirect to('/peeps')
    else
      flash.now[:errors] = ['The email or password is incorrect']
      erb :'sessions/new'
    end
  end

  delete '/sessions' do
    session[:user_id] = nil
    flash.now[:notice] = 'You have logged out'
    erb :'/sessions/new'
  end

  get '/peeps' do
    @peeps = Peep.all
    erb :'peeps/index'
  end

  post '/peeps' do
    @peep = Peep.new(user_id: session[:user_id],
                     text: params[:text],
                     timestamp: Time.now)
    if @peep != "" && !session[:user_id].nil?
      @peep.save
      redirect to('/peeps')
    elsif @peep != ""
      flash.now[:errors] = ['Please log in or register to create a peep']
    else
      flash.now[:errors] = @peep.errors.full_messages
      erb :'peeps/index'
    end
  end

  get '/peeps/:id' do
    @peep = Peep.get(params[:id])
    erb :'peeps/edit_peep'
  end

  put '/peeps/:id' do
    @peep = Peep.get(params[:id])
    peep_text = params[:text]
    if peep_text.empty?
      flash.now[:errors] = ['You cannot submit an empty peep']
      erb :'peeps/edit_peep'
    else
      @peep.update(text: params[:text])
      flash[:success] = 'Peep updated!'
      redirect to('/peeps')
    end
  end

  delete '/peeps/:id' do
    @peep = Peep.get(params[:id])
    @peep.destroy
    flash[:success] = 'Peep deleted!'
    redirect to('/peeps')
  end

  # comments

  get '/comments/:id/new' do
    @peep = Peep.get(params[:id])
    erb :'comments/new_comment'
  end

  get '/comments/:id' do
    @comments = Comment.all
    @id = "#{params[:id]}".to_i
    @peep = Peep.get(@id)
    erb :'comments/index'
  end

  post '/comments/:id' do
    @comment = Comment.new(user_id: session[:user_id],
                           peep_id: params[:id],
                           text: params[:text],
                           timestamp: Time.now)
    if @comment != "" && !session[:user_id].nil?
      @comment.save
      redirect to("/comments/#{params[:id]}")
    elsif @comment != ""
      flash.now[:errors] = ['Please log in or register to make a comment']
    else
      flash.now[:errors] = @comment.errors.full_messages
      erb :'comments/index'
    end
  end

  get '/comments/:id/edit' do
    @id = "#{params[:id]}".to_i
    @comment = Comment.get(@id)
    erb :'comments/edit_comment'
  end

  put '/comments/:id/edit' do
    @comment = Comment.get(params[:id])
    @peep = @comment.peep_id
    comment_text = params[:text]
    if comment_text.empty?
      flash.now[:errors] = ['You cannot submit an empty comment']
      erb :'comments/index'
    else
      @comment.update(text: params[:text])
      flash[:success] = 'Comment updated!'
      redirect to("/comments/#{@peep}")
    end
  end

  delete '/comments/:id' do
    @comment = Comment.get(params[:id])
    @peep = @comment.peep_id
    @comment.destroy
    flash[:success] = 'Comment deleted!'
    redirect to("/comments/#{@peep}")
  end

  # start the server if ruby file executed directly
  run! if app_file == $PROGRAM_NAME

end
