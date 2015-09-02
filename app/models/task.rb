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

class Task < ActiveRecord::Base
  include WithUuid

  belongs_to :reminder

  validates_presence_of :pending, :content, :reminder_id
end
