module API  
  class Auth < Grape::API
    # /api/auth
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
    resource :auth do

      #
      # auth code goes here!
      #

      desc 'Returns pong if logged in correctly.'
      params do
        requires :token, type: String, desc: 'Access token.'
      end
      get :ping do
        authenticate!
        { message: 'pong' }
      end

    end

  end # class end

end  
