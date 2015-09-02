require 'json'

# pagination helper
def paginate(collection, page_num, per_page=5)
  num_pages = (collection.count.to_f / per_page).ceil
  page_num = page_num.to_i

  # fix wonky client requests
  page_num = 1 if page_num.nil? || page_num <= 0
  page_num = num_pages if page_num > num_pages

  collection = collection.slice((page_num - 1) * per_page, per_page)
end

module TodoList
  class TestApi < Grape::API
    resource :test do
      # desc 'Echo service'
      # params do
      #   requires :message, type: String
      # end
      # get '/echo' do
      #   present({ message: params[:message] }, root: 'echo')
      # end

## REMINDERS ############################################
      # INDEX
      get '/reminders' do
        @reminders = paginate(Reminder.all, params[:page])
        present(@reminders, root: 'reminders')
      end

      # CREATE
      post '/reminders' do
        @reminder = Reminder.new(name: params[:name])
        @reminder.save
      end

      # SHOW reminder
      get '/reminders/:id' do
        @reminder = Reminder.find_by(id: params[:id])
        if @reminder.nil?
          return
        end
        present(@reminder, root: 'reminder')
      end

      patch '/reminders/:id' do
        @reminder = Reminder.find(params[:id])
        params.each do |k, v|
          unless k == params[:id]
            @reminder[k] = v
          end
        end
      end

      # INDEX of a single reminder's tasks
      get '/reminders/:id/tasks' do
        @reminder = Reminder.find_by(id: params[:id])
        @tasks = paginate(@reminder.tasks, params[:page])
        present(@tasks, root: 'tasks')
      end

      # DELETE
      delete '/reminders/:id' do
        Reminder.destroy(params[:id])
        Task.destroy_all(reminder_id: params[:id])
      end


## TASKS #########################################
      # INDEX
      get '/tasks' do
        @tasks = paginate(Task.all, params[:page])
        present(@tasks, root: 'tasks')
      end

      # SHOW task
      get '/tasks/:id' do
        @task = Task.find(params[:id])
        if @task.nil?
          return
        end
        present(@task, root: 'task')
      end

      # CREATE
      post '/tasks' do
        @task = Task.new(content: params[:content], reminder_id: params[:reminder_id], pending: true)
        @task.save
      end

      # UPDATE
      patch '/tasks/:id' do
        @task = Task.find(params[:id])
        params.each do |k, v|
          unless k == :id
            @task[k] = v
          end
        end
        @task.save
      end

      # DELETE
      delete '/tasks/:id' do
        Task.destroy(params[:id])
      end
    end
  end

end
