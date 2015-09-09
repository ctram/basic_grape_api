# Basic Grape App

Basic API endpoint created with Grape, Grape-Entity and Rails.

- Includes CRUD operations.
- Basic pagination.
- Enforces parameters.
- Enforces a max of 10 items per reminder.
- Able to filter by status.
- Includes tests for models and HTTP requests.

Routes/resources:
```
/api/v1/reminders (INDEX and CREATE for reminders)
/api/v1/reminders/:uuid (SHOW, UPDATE, DELETE reminder)
/api/v1/reminders/:uuid/tasks (INDEX and CREATE for tasks)
/api/v1/reminders/:uuid/tasks/:task_uuid (SHOW, UPDATE, DELETE task)
```

To run:

Clone the repository. Traverse into the ```todolist-api``` directory and run ```rails server```.
