module TodoList
  class TestApi < Grape::API
    resource :test do
      desc 'Echo service'
      params do
        requires :message, type: String
      end
      get '/echo' do
        present({ message: params[:message] }, root: 'echo')
      end
    end
  end
end
