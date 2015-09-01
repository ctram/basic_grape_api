Rails.application.routes.draw do
  mount TodoList::Api => '/'
end
