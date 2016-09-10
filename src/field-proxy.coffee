class FieldProxy extends QingModule

  opts:
    group: null
    data: null
    field: null

  constructor: ->
    super
    { @group, @data, @field } = @opts

    @el = $('<a class="district-field-proxy" href="javascript:;"></a>').hide()
      .appendTo @group.el
    @el.on "click", (e) =>
      @setActive(true)

  restore: ->
    if code = @field.val()
      @setItem item = @data[code]
      @trigger "restore", [item]

  isFilled: ->
    !!@field.val()

  setActive: (active) ->
    @el.text(@el.text() || "_").toggle(active)
    @highlight(active)
    @trigger "active", @el.data("item") if active
    @

  highlight: (active) ->
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
