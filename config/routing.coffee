controllers = require('../controllers')

exports.configure = (app) ->
    app.get('/', controllers.todo.index)

    #rest
    app.post('/api/todo', controllers.todo.create)

    app.post('/api/todo/:todoId/items', controllers.todo.items.create)
    app.put('/api/todo/:todoId/items/:itemId', controllers.todo.items.save)
    app.delete('/api/todo/:todoId/items/:itemId', controllers.todo.items.delete)

