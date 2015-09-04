module TodoList
  class RemindersApi < Grape::API
    # TODO: review that app does not crash with bad inputs
    # TODO: Add authorization - must be authorized to write

    resource :reminders do

      # Reminders - INDEX
      desc 'Get a full list of reminders'
      get do
        @reminders = paginate(Reminder.all, params[:page])
        present @reminders, with: TodoList::Entities::Reminder, root: 'reminders'
      end

      # Reminder - CREATE
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

        # Reminder - SHOW
        desc 'Retrieves a reminder given its uuid'
        get do
          present @reminder, with: TodoList::Entities::Reminder, root: 'reminder'
        end

        # Reminder - UPDATE
        desc 'Upate a reminder given its uuid and updated info'
        patch do
          @reminder.attributes.each do |k, v|
            if params.has_key?(k)
              @reminder.update_attribute(k.to_sym, params[k])
            end
          end
        end

        # Reminder - DELETE
        desc "Delete a reminder and all it's tasks given its uuid"
        delete do
          Task.destroy_all(reminder_id: @reminder.id)
          @reminder.destroy
        end

        # 'tasks' resource is nested under a given reminder since a task must be associated with a given reminder and cannot be free floating
        resource :tasks do

          # Tasks - INDEX
          desc "List all reminder's tasks"
          get do
            status = params[:status] # Valid statuses: 'done', 'pending', 'all' (default)

            if status == 'pending'
              filtered_tasks = @reminder.tasks.where(pending: true)
            elsif status == 'done'
              filtered_tasks = @reminder.tasks.where(pending: false)
            else
              filtered_tasks = @reminder.tasks
            end

            @tasks = paginate(filtered_tasks, params[:page])

            present(@tasks, with: TodoList::Entities::Task, root: 'tasks')
          end

          # Task - CREATE
          params do
            requires :content, type: String
          end
          desc 'Create a task for the reminder'
          post do
            # Restrict number of tasks to no more than 10 per reminder
            error!('cannot create more than 10 tasks per reminder') if @reminder.tasks.count == 10

            Task.create!(reminder_id: @reminder.id, content: params[:content], pending: true)
          end

          resource ':task_uuid' do
            before do
              @task = Task.find_by_uuid(params[:task_uuid])
              error!('task not found', 404) if @task.nil?
            end

            # Task - SHOW
            desc "Show a single reminder task"
            get do
              present(@task, with: TodoList::Entities::Task, root: 'task')
            end

            # Task - UPDATE
            desc 'Update a single reminder task'
            patch do
              @task.attributes.each do |k, v|
                next if k == 'uuid'
                if params.has_key?(k)
                  if k == 'pending'
                    if params[:pending] == 'true'
                      @task.update_attribute(k.to_sym, true)
                    else
                      @task.update_attribute(k.to_sym, false)
                    end
                  else
                    @task.update_attribute(k.to_sym, params[:content])
                  end
                end
              end
            end

            #  Task - DELETE
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
# Returns array of Active Record objects for a given page number and per-page amount
def paginate(collection, page_num, per_page=5)
  num_pages = (collection.count.to_f / per_page).ceil
  page_num = page_num.to_i

  # fix wonky client requests
  page_num = 1 if page_num.nil? || page_num <= 0
  page_num = num_pages if page_num > num_pages

  collection.slice((page_num - 1) * per_page, per_page)
end
