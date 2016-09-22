class FieldProxy extends QingModule

  opts:
    group: null
    data: null
    field: null

  _init: ->
    { @group, @data, @field } = @opts

    @el = $('<a class="district-field-proxy" href="javascript:;"></a>').hide()
      .appendTo @group.el
    @el
      .on "click", (e) =>
        @setActive(true)
        false
      .on "keydown", (e) =>
        if $(e.target).is(@el) and e.which == 13
          @setActive(true)

  restore: ->
    if code = @field.val()
      @setItem item = @data[code]
      @trigger "restore", [item]

  isFilled: ->
    !!@field.val()

  setActive: (active) ->
    @el.toggle(active)
    @highlight(active)
    @trigger "active", @getItem() if active
    @

  highlight: (active) ->
    @el.attr "tabindex", (if active then -1 else 0)
    @el.toggleClass "active", active

  getItem: ->
    @el.data("item")

  setItem: (item) ->
    @el.text(item.name).data("item", item).show()
    @field.val item.code
    @

  clear: ->
    @field.val null
    @el.text("").data("item", null).hide()
    @

module.exports = FieldProxy
