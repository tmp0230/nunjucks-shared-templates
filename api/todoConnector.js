// Generated by CoffeeScript 1.4.0
(function() {
  var ERROR_RATE;

  ERROR_RATE = 0.3;

  exports.getTodos = function(cb) {
    return process.nextTick(function() {
      if (Math.random() < ERROR_RATE) {
        return cb(true);
      } else {
        return cb(null, [
          {
            id: 1200,
            items: [
              {
                id: 1,
                'desc': 'Brush teeth',
                done: false
              }, {
                id: 2,
                desc: 'Put on pants',
                done: true
              }
            ]
          }, {
            id: 1300,
            items: []
          }
        ]);
      }
    });
  };

  exports.createTodo = function(cb) {
    return process.nextTick(function() {
      if (Math.random() < ERROR_RATE) {
        return cb(true);
      } else {
        return cb(null, {
          id: ~~(Math.random() * 1000) + 1000,
          items: []
        });
      }
    });
  };

  exports.saveTodoItem = function(item, todoId, cb) {
    return process.nextTick(function() {
      item.todoId = todoId;
      if (Math.random() < ERROR_RATE) {
        return cb(true);
      } else {
        return cb(null, item);
      }
    });
  };

  exports.deleteTodoItem = function(item, todoId, cb) {
    return process.nextTick(function() {
      item.todoId = todoId;
      if (Math.random() < ERROR_RATE) {
        return cb(true);
      } else {
        return cb(null, item);
      }
    });
  };

  exports.createTodoItem = function(desc, todoId, cb) {
    return process.nextTick(function() {
      var item;
      item = {
        id: ~~(Math.random() * 1000),
        desc: desc,
        done: false
      };
      if (Math.random() < ERROR_RATE) {
        return cb(true);
      } else {
        return cb(null, item);
      }
    });
  };

}).call(this);
