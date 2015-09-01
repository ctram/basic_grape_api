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

class Reminder < ActiveRecord::Base
  include WithUuid
  has_many :tasks
end
