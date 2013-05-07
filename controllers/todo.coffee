async = require('async')
_ = require('underscore')
templating = require('../config/templating')
api = require('../api/todoConnector')

exports.index = (req, res) ->

  api.getTodos((err, todos=[]) ->
    if err
      req.flash('error', 'Could not retrieve todo lists')
    res.render('todo/index.html', {todoLists: todos})
  )


exports.create = (req, res) ->
  api.createTodo((err, todo) ->
    if err
      req.flash('error', 'Could not add another todo list')
    res.json(todo)
  )

exports.items = {
  create: (req, res) ->
    api.createTodoItem(req.body.desc, req.params.todoId, (err, item) ->
      if err
        req.flash('error', 'Could not create todo item')
      res.json(item)
    )

  save: (req, res) ->
    req.body.done = !! req.body.done
    api.saveTodoItem(req.body, req.params.todoId, (err, item) ->
      if err
        req.flash('error', 'Could not save todo item')
      res.json(item)
    )

  delete: (req, res) ->
    api.deleteTodoItem(req.body, req.params.todoId, (err, item) ->
      if err
        req.flash('error', 'Could not delete todo item')
      res.json(item)
    )
}


