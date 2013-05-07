(function() {
  Behavior2.Class('app', 'div.todoapp', {
    click: {
      'a.add-todo-list': 'addTodoList'
    }
  }, function($ctx, that) {
    var $cont;

    $cont = $ctx.find('.todoapp-container');
    that.addTodoList = function(e) {
      e.preventDefault();
      return $.post($(e.currentTarget).attr('href'), function(data) {
        var tpl;

        if (!data.hasError) {
          $cont.prepend(X.macro('todoList', data.content, tpl = 'todo.html'));
        }
        return Behavior2.contentChanged();
      });
    };
  });

  Behavior2.Class('todo-items', 'section.todo-list', {
    keypress: {
      '.todo-header input.new-todo': 'create',
      '.main input.todo-input': 'edit'
    },
    click: {
      '.main input.check': 'save',
      '.main button.delete-item': 'delete'
    },
    dblclick: {
      '.main .todo-text': 'showEditor'
    },
    blur: {
      '.main input.todo-input': 'hideEditor'
    }
  }, function($ctx, that) {
    var $list, $toggle, ajax, id, plainSave, renderItem, renderUI, updateUI;

    id = $ctx.data('id');
    $list = $ctx.find('.todo-list');
    $toggle = $ctx.find('.main input.toggle-all');
    ajax = function(e, method, cb) {
      var $form, desc, itemId;

      $form = $(e.currentTarget).closest('form');
      desc = $.trim($form.find('.todo-input').val());
      if (desc === '') {
        return X.flash({
          'error': ['You must enter a description']
        });
      }
      itemId = $form.data('id');
      return $.ajax({
        url: "/api/todo/" + id + "/items/" + itemId,
        dataType: 'json',
        method: method,
        data: $form.serializeArray()
      }).done(function(data) {
        return cb(data, itemId, $form);
      });
    };
    renderItem = function(data) {
      return X.macro('todoItem', data.content, 'todo.html');
    };
    plainSave = function(e, cb) {
      e.preventDefault();
      return ajax(e, 'put', function(data, itemId, $form) {
        if (!data.hasError) {
          $form.replaceWith(renderItem(data));
          return cb();
        }
      });
    };
    renderUI = function() {
      var $checks, doneItems, totalItems;

      $checks = $ctx.find('input.check');
      totalItems = $checks.length;
      doneItems = $checks.filter(':checked').length;
      $ctx.find('.todo-count').text("" + totalItems + " to-do items / " + doneItems + " completed");
      return $toggle.prop('checked', totalItems === doneItems);
    };
    updateUI = function(fn) {
      return function(e) {
        return fn(e, renderUI);
      };
    };
    that.initialize = renderUI;
    that.save = updateUI(plainSave);
    that.create = updateUI(function(e, cb) {
      var $target, val;

      if (e.keyCode === 13) {
        $target = $(e.currentTarget);
        val = $target.val();
        if ($.trim(val) === '') {
          return X.flash({
            'error': ['You must enter a description']
          });
        } else {
          return $.post("/api/todo/" + id + "/items/", {
            desc: val
          }, function(data) {
            if (!data.hasError) {
              $list.prepend(renderItem(data));
              $target.val('');
              return cb();
            }
          });
        }
      }
    });
    that["delete"] = updateUI(function(e, cb) {
      e.preventDefault();
      return ajax(e, 'delete', function(data, itemId, $form) {
        if (!data.hasError) {
          $form.remove();
          return cb();
        }
      });
    });
    that.showEditor = function(e) {
      var $editor, $target;

      $target = $(e.currentTarget);
      $editor = $target.parent().next();
      return $editor.show().find('.todo-input').focus().val($target.find('.value').text());
    };
    that.hideEditor = function(e) {
      return $(e.currentTarget).parent().hide();
    };
    that.edit = function(e) {
      if (e.keyCode === 13) {
        e.preventDefault();
        that.save(e);
        return that.hideEditor(e);
      }
    };
  });

}).call(this);
