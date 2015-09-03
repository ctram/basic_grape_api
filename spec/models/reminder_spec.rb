# == Schema Information
#
# Table name: reminders
#
#  id         :integer          not null, primary key
#  name       :string
#  uuid       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Reminder, type: :model do

  # Test standard associations
  it do
    should have_many(:tasks).class_name('Task')
  end

  # Test presence of basic model attributes
  it do
    should validate_presence_of(:name)
  end
end

RSpec.describe Reminder, type: :request do
  let(:tom_list) {Fabricate(:reminder, name:"Tom's List")}
  let(:tom_list_uuid) {tom_list.uuid}
  let(:tom_list_id) {tom_list.id}

  before do
    4.times do
      Fabricate(:reminder)
    end

    3.times do
      Fabricate(:task, reminder_id: tom_list_id)
    end

    2.times do
      task = Fabricate(:task, reminder_id: tom_list_id)
      task.update_attribute(:pending, false)
    end
  end

  context 'INDEX' do
    it 'should receive multiple JSON objects' do
      get '/api/v1/reminders'
      arr_reminders = JSON.parse(response.body)['reminders']
      expect(arr_reminders.count).to eq(5)
    end

    it 'should have pagination and show no more than 5 reminders' do
      10.times do
        Fabricate(:reminder)
      end

      get '/api/v1/reminders'
      res = JSON.parse(response.body)
      expect(res['reminders'].count).to eq(5)
    end
  end

  context 'CREATE' do
    it 'should create a new reminder' do
      post '/api/v1/reminders?name=NewList'
      res = JSON.parse(response.body)
      expect(res['reminder']['name']).to eq('NewList')
    end
  end

  context 'SHOW' do
    it 'should show the correct reminder' do
      uuid = tom_list.uuid
      get '/api/v1/reminders/' + uuid
      reminder = JSON.parse(response.body)['reminder']
      expect(reminder['name']).to eq("Tom's List")
    end
  end

  context 'SHOW with tasks' do
    it 'should have the correct number of tasks' do
      get '/api/v1/reminders/' + tom_list_uuid + '/tasks'
      arr_tasks = JSON.parse(response.body)['tasks']
      expect(arr_tasks.count).to eq(5)
    end

    it 'should show tasks that belong to it' do
      get '/api/v1/reminders/' + tom_list_uuid + '/tasks'
      arr_tasks = JSON.parse(response.body)['tasks']
      arr_tasks.count.times do |i|
        expect(arr_tasks[i]['reminder_id']).to eq(tom_list_id)
      end
    end

    it 'should show only pending tasks' do
      get '/api/v1/reminders/' + tom_list_uuid + '/tasks?status=pending'
      arr_tasks = JSON.parse(response.body)['tasks']
      expect(arr_tasks.count).to eq(3)
    end

    it 'should show only completed tasks' do
      get '/api/v1/reminders/' + tom_list_uuid + '/tasks?status=done'
      arr_tasks = JSON.parse(response.body)['tasks']
      expect(arr_tasks.count).to eq(2)
    end
  end

  context 'UPDATE' do
    it 'should update its name' do
      patch '/api/v1/reminders/' + tom_list_uuid + "?name=DiffName"
      get '/api/v1/reminders/' + tom_list_uuid
      reminder = JSON.parse(response.body)['reminder']
      expect(reminder['name']).to eq("DiffName")
    end
  end

  context 'DELETE' do
    it 'should successfully delete' do
      get '/api/v1/reminders'
      old_count = JSON.parse(response.body)['reminders'].count

      delete '/api/v1/reminders/' + tom_list_uuid

      get '/api/v1/reminders'
      new_count = JSON.parse(response.body)['reminders'].count

      expect(new_count).to eq(old_count - 1)

      get '/api/v1/reminders/' + tom_list_uuid
      res = JSON.parse(response.body)
      expect(res['error']).to eq('reminder not found')
    end
  end
end
