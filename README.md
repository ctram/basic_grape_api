# Rails Engineer at Gild #

The program you will write for this assignment will implement a very simple REST json
APIs-only Rails application using using [ruby-grape gem](https://github.com/ruby-grape/grape) and will implement a Reminder app.

These are the high level requirements:

1. List / Create / Delete / Update `Reminders`

  Reminders are like a post-it and each `Reminder` can contain multiple `Task`
  A Task is an element of your reminder's board. A Reminder can hold up to 10 tasks

2. List / Create / Delete / Update `Tasks` linked to a `Reminder` object

  A `Reminder` is an item of your todo list
  Along with a label, a task has also a pending flag, which is set to `true` by default

Gild has already setup a working application scaffold for you with an initial draft of some of APIs
Spend some time to look at the enclosed sample code and at grape gem documentation before starting the code

# Implementation of missing requirements

1. CRUD operations for `Reminder` and `Task` objects
2. Basic pagination for endpoints that could return a long list of elements
3. Enforce required parameters check
4. Enforce max 10 items for each reminder check
5. Tasks status filtering: Each Task has a status, the status can be used as filter to show tasks that are still pending and tasks that are done
5. General errors handling: Your app should not crash if a wrong message is sent

## Bonus items

1. Big plus if you can add some rspec around your code
2. Big plus for a very basic stateless authorization mechanism. All the read-only operations can be performed by everyone anonymously. Write operations should require stateless authentication.
You don't need to handle multiple users, a proof of concept with some hardcoded data is OK

## System requirements

1. Ruby 2.1.2

## How to install

From your console, navigate into the main project's directory:

```bash
  $ cd todo-list-api
```
Install gem dependencies:

```bash
  $ bundle install
```

Prepare the database (sqlite3)

```bash
  $ bundle exec rake db:migrate
```

Launch your app

```bash
  $ bundle exec rails s
```

Test your app

```bash
  $ open 'http://localhost:3000/api/v1/test/echo?message=hello'
```


## Some external references

* https://github.com/ruby-grape/grape
* https://github.com/ruby-grape/grape-entity
