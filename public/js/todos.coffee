Behavior2.Class('app', 'div.todoapp', {
  click: {
    'a.add-todo-list' : 'addTodoList'
  }
}, ($ctx, that) ->

  $cont = $ctx.find('.todoapp-container')
  that.addTodoList = (e) ->
    e.preventDefault()
    $.post($(e.currentTarget).attr('href'), (data) ->
      $cont.prepend(X.macro('todoList', data.content, tpl='todo.html')) if not data.hasError
      Behavior2.contentChanged()
    )

  return;
)

Behavior2.Class('todo-items', 'section.todo-list', {
  keypress: {
    '.todo-header input.new-todo' : 'create'
    '.main input.todo-input' : 'edit'
  }
  click: {
    '.main input.check' : 'save',
    '.main button.delete-item': 'delete'
  },
  dblclick: {
    '.main .todo-text': 'showEditor'
  },
  blur: {
    '.main input.todo-input' : 'hideEditor'
  }
}, ($ctx, that) ->

  id = $ctx.data('id')
  $list = $ctx.find('.todo-list');
  $toggle = $ctx.find('.main input.toggle-all')

  ajax = (e, method, cb) ->
    $form = $(e.currentTarget).closest('form');
    desc = $.trim($form.find('.todo-input').val())
    if desc == ''
      return X.flash({'error': ['You must enter a description']})

    itemId = $form.data('id');
    $.ajax({
      url: "/api/todo/#{id}/items/#{itemId}",
      dataType: 'json',
      method: method,
      data: $form.serializeArray()
    }).done((data) ->
      cb(data, itemId, $form)
    )

  renderItem = (data) ->
    return X.macro('todoItem', data.content, 'todo.html')

  plainSave = (e, cb) ->
    e.preventDefault()
    ajax(e, 'put', (data, itemId, $form) ->
      if not data.hasError
        $form.replaceWith(renderItem(data))
        cb()
    )

  renderUI = () ->
    $checks = $ctx.find('input.check')
    totalItems = $checks.length
    doneItems = $checks.filter(':checked').length
    $ctx.find('.todo-count').text("#{totalItems} to-do items / #{doneItems} completed")

    $toggle.prop('checked', totalItems == doneItems)

  updateUI = (fn) ->
    return (e) ->
      fn(e, renderUI)

  that.initialize = renderUI
  that.save = updateUI(plainSave)

  that.create = updateUI((e, cb) ->
    if e.keyCode == 13
      $target = $(e.currentTarget)
      val = $target.val()
      if $.trim(val) == ''
        X.flash({'error': ['You must enter a description']})
      else
        $.post("/api/todo/#{id}/items/", {desc: val}, (data) ->
          if not data.hasError
            $list.prepend(renderItem(data))
            $target.val('')
            cb()
        )
  )

  that.delete = updateUI((e, cb) ->
    e.preventDefault()
    ajax(e, 'delete', (data, itemId, $form) ->
      if not data.hasError
        $form.remove()
        cb()
    )
  )

  that.showEditor = (e) ->
    $target = $(e.currentTarget)
    $editor = $target.parent().next()
    $editor.show().find('.todo-input').focus().val($target.find('.value').text())

  that.hideEditor = (e) ->
    $(e.currentTarget).parent().hide()

  that.edit = (e) ->
    if e.keyCode == 13
      e.preventDefault()
      that.save(e)
      that.hideEditor(e)


  return;
)