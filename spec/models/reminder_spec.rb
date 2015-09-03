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
    Fabricate(:reminder)
    Fabricate(:reminder)
    Fabricate(:reminder)
    Fabricate(:reminder)

    Fabricate(:task, reminder_id: tom_list_id)
    Fabricate(:task, reminder_id: tom_list_id)
    Fabricate(:task, reminder_id: tom_list_id)
    Fabricate(:task, reminder_id: tom_list_id)
    Fabricate(:task, reminder_id: tom_list_id)
  end

  context 'INDEX' do
    it 'should receive multiple JSON objects' do
      get '/api/v1/reminders'
      arr_reminders = JSON.parse(response.body)['reminders']
      expect(arr_reminders.count).to eq(5)
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
  end

end
