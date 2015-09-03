module TodoList
  module Entities
    class Task < Entities::Base
      expose(:content)
      expose(:pending)
    end
  end
end
