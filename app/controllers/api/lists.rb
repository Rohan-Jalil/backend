module API  
  class Lists < Grape::API
    # /api/lists
    mount API::Auth
    # all of your methods go here!
        
  end
end  