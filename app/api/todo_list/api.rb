module TodoList
  class Api < Grape::API
    version 'v1'
    format :json
    prefix :api
    # mount TestApi
    mount RemindersApi
  end
end
