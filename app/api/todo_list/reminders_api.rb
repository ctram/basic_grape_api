module TodoList
  class RemindersApi < Grape::API

    resource :reminders do
      # INDEX
      desc 'Get a full list of reminders'
      get do
        @reminders = paginate(Reminder.all, params[:page])
        present @reminders, with: TodoList::Entities::Reminder, root: 'reminders'
      end

      # CREATE
      desc 'Create a new reminder'
      params do
        requires :name, type: String
      end
      post do
        reminder = Reminder.create!(name: params[:name])
        present reminder, with: TodoList::Entities::Reminder, root: 'reminder'
      end

      resource ':uuid' do
        before do
          @reminder = Reminder.find_by_uuid(params[:uuid])
          error!('reminder not found', 404) if @reminder.nil?
        end

        # SHOW
        desc 'Retrieves a reminder given its uuid'
        get do
          present @reminder, with: TodoList::Entities::Reminder, root: 'reminder'
        end

        # UPDATE
        desc 'Upate a reminder given its uuid and updated info'
        patch do
          params.each do |k, v|
            @reminder[k] = v
          end
          @reminder.save
        end

        # DELETE
        desc "Delete a reminder and all it's tasks given its uuid"
        delete do
          # Task.destroy_all(reminder_id: @reminder.id)
          @reminder.destroy
        end

        # have 'tasks' resource nested under a given reminder since a task must be associated with a given reminder
        resource :tasks do

          # INDEX
          desc "List all reminder's tasks"
          get do
            @tasks = paginate(@reminder.tasks, params[:page])
            present(@tasks, with: TodoList::Entities::Task, root: 'tasks')
          end

          # CREATE
          params do
            requires :content, type: String
          end
          desc 'Create a task for the reminder'
          post do
            # restrict number of tasks to no more than 10 per reminder
            error!('cannot create more than 10 tasks per  reminder') if @reminder.tasks.count == 10

            Task.create!(reminder_id: @reminder.id, content: params[:content], pending: true)
          end

          resource ':task_uuid' do
            before do
              @task = Task.find_by_uuid(params[:task_uuid])
              error!('task not found', 404) if @task.nil?
            end

            # SHOW
            desc "Show a single reminder task"
            get do
              present(@task, with: TodoList::Entities::Task, root: 'task')
            end

            # UPDATE
            desc 'Update a single reminder task'
            patch do
              @task.attributes.each do |k, v|
                next if k == 'uuid'
                if params.has_key?(k)
                  @task[k] = params[k]
                end
              end

              @task.save
            end

            #  DELETE
            desc 'Delete a single reminder task'
            delete do
              @task.destroy
            end
          end
        end
      end
    end
  end
end


# TODO: probably should move this helper method somewhere else.
# pagination helper
def paginate(collection, page_num, per_page=5)
  num_pages = (collection.count.to_f / per_page).ceil
  page_num = page_num.to_i

  # fix wonky client requests
  page_num = 1 if page_num.nil? || page_num <= 0
  page_num = num_pages if page_num > num_pages

  collection.slice((page_num - 1) * per_page, per_page)
end
