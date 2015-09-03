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
