ListView = require "./view/list-view.coffee"
Ref = require "./view/ref.coffee"

class Controller extends QingModule

  opts:
    target: null
    dataStore: null
    type: null
    codes: []

  constructor: ->
    super
    { @target, @type, @dataStore, @codes } = @opts
    @field = @target.find("[data-#{@type}-field]")
    @dataMap = @dataStore.findByType(@type)
    @listView = new ListView()
    @ref = new Ref()
    @_init()
    @_bind()

  _init: ->
    code = @field.val()
    if item = @dataMap[code]
      @current = item
      @ref.linkTo(item)
      @listView.highlightItem(item)
    @render()

  _bind: ->
    @listView.on "select", (e, code) =>
      @selectByCode code
      @listView.hide()
      @trigger "afterSelect", [@]
      false

    @ref.on "visit", (e, code) =>
      @selectByCode code
      @listView.show()
      @trigger "visit", @
      false

  selectByCode: (code) ->
    @current = @dataMap[code]
    @ref.linkTo @current
    @listView.highlightItem @current
    @field.val @current.code
    @

  reset: ->
    @field.val null
    @ref.reset()
    @

  setCodes: (codes) ->
    @codes = codes
    @

  isSelected: ->
    !!@field.val()

  render: ->
    @codes = Object.keys(@dataMap) if @codes == "all"
    return unless @codes
    items = []
    items.push @dataMap[code] for code in @codes
    @listView.render(items)
    @listView.highlightItem @dataMap[@current?.code]
    @listView.show()
    @

module.exports = Controller
