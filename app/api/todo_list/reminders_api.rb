module TodoList
  class RemindersApi < Grape::API
    resource :reminders do
      desc 'Get a full list of reminders'
      # XXX TODO: Implement pagination
      get do
        present Reminder.all, with: TodoList::Entities::Reminder, root: 'reminders'
      end

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
        desc 'Retrieves a reminder given its uuid'
        get do
          present @reminder, with: TodoList::Entities::Reminder, root: 'reminder'
        end
        # XXX TODO: Implement missing CRUD operations: UDATE / DELETE
      end
    end
  end
end
