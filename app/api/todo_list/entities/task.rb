module TodoList
  module Entities
    class Task < Entities::Base
      expose(:content)
      expose(:pending)
      expose(:reminder_id)
    end
  end
end
