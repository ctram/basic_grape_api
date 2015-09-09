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
/api/v1/reminders (INDEX and CREATE)
/api/v1/reminders/:uuid (SHOW reminder)
/api/v1/reminders/:uuid/tasks (INDEX of tasks)
/api/v1/reminders/:uuid/tasks/:task_uuid (SHOW task)
```
