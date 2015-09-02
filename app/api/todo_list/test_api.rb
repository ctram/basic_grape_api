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
      get '/cats' do
        debugger

      end


      get '/reminders' do
        @reminders = Reminder.all

        present(@reminders)
      end

      post '/reminders' do
        debugger
        @reminder = Reminder.new(name: params[:name])
        @reminder.save
      end


    end
  end

end
