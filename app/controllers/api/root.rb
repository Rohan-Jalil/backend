module API  
  class Root < Grape::API
    # before_action :doorkeeper_authorize!
    prefix "api"
    format :json
    #error_format :json
    version 'v1', :using => :header, :vendor => 'backend'
    helpers do
      def current_user
        # @current_user ||= User.authorize!(env)
        if (params[:token] == "1")
          true
        end
      end

      def authenticate!
        error!('401 Unauthorized', 401) unless current_user
      end
    end
    #ONLY LOGIN WORKS WITH POST
resource "login" do
    params do
        requires :email, type: String, desc: 'Email'
        requires :password, type: String, desc: 'password'
      end
      get do
        error!('401 Unauthorized', 401)
      end
      put do
        error!('401 Unauthorized', 401)
      end
      delete do
        error!('401 Unauthorized', 401)
      end
      post do
        authenticate!
        @usr = User.select("id, name, login_count").find_by({email:params[:email],password:params[:password]}) rescue error!('403 Invalid Login', 403)
        @usr.update_attribute(:login_count, @usr.login_count + 1)
        return @usr
      end
end
   #ONLY USER WORKS WITH GET / POST / PUT / DELETE
resource "user" do
    desc 'Returns pong if logged in correctly.'
      params do
        requires :token, type: String, desc: 'Access token.'
      end
      get do
        authenticate!
        User.select("id, name, login_count")
      end
      get ':id' do
        authenticate!
        User.select("id, name, login_count").find(params[:id]) rescue error!('404 Not Found', 404)
      end
      delete ':id' do
        authenticate!
        User.delete(params[:id]) rescue error!('500 Internal Server Error', 500)
      end
      post do
        authenticate!
        params do
            requires :name, type: String, desc:'Name of User Account'
            requires :email, type: String, desc:'Email of User Account'
            requires :password, type: String, desc:'Password for User Account'
        end
        User.create({name: params[:name], email: params[:email], password: params[:password]})
      end
      put do
        authenticate!
        params do
            requires :id, type: Int, dec:'User Data Id'
            requires :name, type: String, desc:'Name of User Account'
            requires :email, type: String, desc:'Email of User Account'
            requires :password, type: String, desc:'Password for User Account'
        end
        @user = User.find(params[:id]) rescue error!('403 Invalid Data', 403)
        @user.update({name: params[:name], email: params[:email], password: params[:password]})
      end
    end





  end
end 