#this is a dummy backend api.
#it will randomly throw errors

ERROR_RATE = 0.0

exports.getTodos = (cb) ->
  process.nextTick () ->
    if Math.random() < ERROR_RATE
      cb(true)
    else
      cb(null, [{id: 1200, items: [{id:1, 'desc': 'Brush teeth', done: false}, {id:2, desc: 'Put on pants', done: true}]}, {id: 1300, items: []}])

exports.createTodo = (cb) ->
  process.nextTick () ->
    if Math.random() < ERROR_RATE
      cb(true)
    else
      cb(null, {id: ~~(Math.random() * 1000)+1000, items: []})

exports.saveTodoItem = (item, todoId, cb) ->
  process.nextTick () ->
    item.todoId = todoId
    if Math.random() < ERROR_RATE
      cb(true)
    else
      cb(null, item)


exports.deleteTodoItem = (item, todoId, cb) ->
  process.nextTick () ->
    item.todoId = todoId
    if Math.random() < ERROR_RATE
      cb(true)
    else
      cb(null, item)


exports.createTodoItem = (desc, todoId, cb) ->
  process.nextTick () ->
    item = {id:~~(Math.random() * 1000), desc: desc, done: false}
    if Math.random() < ERROR_RATE
      cb(true)
    else
      cb(null, item)


