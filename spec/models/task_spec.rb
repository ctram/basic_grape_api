# == Schema Information
#
# Table name: tasks
#
#  id          :integer          not null, primary key
#  content     :string
#  reminder_id :integer
#  uuid        :string
#  pending     :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Task, type: :model do

  # Test standard associations
  it do
    should belong_to(:reminder).class_name('Reminder')
  end

  # Test presence of model attributes
  it do
    should validate_presence_of(:reminder_id)
    should validate_presence_of(:content)
  end
end

RSpec. describe Task, type: :request do
  let(:tom_list) {Fabricate(:reminder, name: "Tom's List")}
  let(:tom_list_id) {tom_list.id}
  let(:tom_list_uuid) {tom_list.uuid}

  before do
    Fabricate(:task, content: 'First Task', reminder_id: tom_list_id)
    Fabricate(:task, content: 'Second Task', reminder_id: tom_list_id)
  end

  context 'CREATE' do
    it 'should create a new task for a reminder' do
      get '/api/v1/reminders/' + tom_list_uuid + '/tasks'
      res = JSON.parse(response.body)
      old_num_tasks = res['tasks'].count

      post '/api/v1/reminders/' + tom_list_uuid + '/tasks?content=taskinfo'

      get '/api/v1/reminders/' + tom_list_uuid + '/tasks'
      res = JSON.parse(response.body)
      new_num_tasks = res['tasks'].count

      expect(new_num_tasks).to eq(old_num_tasks + 1)
      expect(res['tasks'].first['reminder_id']).to eq(tom_list_id)
    end

    it 'should not create more than 10 tasks for a reminder' do
      15.times do
        post '/api/v1/reminders/' + tom_list_uuid + '/tasks?content=taskinfo'
      end

      expect(tom_list.tasks.count).to eq(10)
    end
  end

  context 'UPDATE' do
    it 'should update' do
      task = Fabricate(:task, reminder_id: tom_list_id)
      patch '/api/v1/reminders/' + tom_list_uuid + '/tasks/' + task.uuid + '?content=updated-content'

      get '/api/v1/reminders/' + tom_list_uuid + '/tasks/' + task.uuid
      res = JSON.parse(response.body)
      expect(res['task']['content']).to eq('updated-content')
    end
  end

  context 'DELETE' do
    it 'should delete' do
      task = Fabricate(:task, reminder_id: tom_list_id)
      get '/api/v1/reminders/' + tom_list_uuid + '/tasks'
      res = JSON.parse(response.body)
      old_num_tasks = res['tasks'].count

      delete '/api/v1/reminders/' + tom_list_uuid + '/tasks/' + task.uuid

      get '/api/v1/reminders/' + tom_list_uuid + '/tasks'
      res = JSON.parse(response.body)
      new_num_tasks = res['tasks'].count

      expect(new_num_tasks).to eq(old_num_tasks - 1)
    end
  end
end
