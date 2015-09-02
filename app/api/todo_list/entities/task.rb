module TodoList
  module Entities
    class Task < Entities::Base
      expose(:content)
    end
  end
end
