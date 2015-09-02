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
        @reminder = Reminder.new(name: params[:name])
        @reminder.save
      end

      get '/reminders/:id' do
        @reminder = Reminder.find_by(id: params[:id])
        present(@reminder, root: 'reminder')
      end

      get '/reminders/:id/tasks' do
        @reminder = Reminder.find_by(id: params[:id])
        @tasks = @reminder.tasks
        present(@tasks, root: 'tasks')
      end


      get '/tasks' do
        @tasks = Task.all
        present(@tasks)
      end

      post '/tasks' do
        debugger
        @task = Task.new(content: params[:content], reminder_id: params[:reminder_id], pending: true)
        @task.save
      end

      patch '/tasks/:id' do
        debugger
        @task = Task.find(params[:id])
        params.each do |k, v|
          unless k == :id
            @task[k] = v
          end
        end
        @task.save
      end

      delete '/tasks/:id' do
        Task.delete(params[:id])
      end


    end
  end

end
