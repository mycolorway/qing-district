class Controller
  constructor: (@context, @type, @codes=[]) ->
    @ref = $('<a class="district-item" href="javascript:;"></a>').hide()
    @list = $('<div class="district-list"><dl><dd></dd></dl></div>').hide()
    @field = @context.el.find("[data-#{@type}-field]")
    @dataMap = @context.data[@type]
    @_bind()
    @_init()

  _init: ->
    code = @field.val()
    if data = @dataMap[code]
      @current = data
      @ref.text(data.name).show()
      @list.find("[data-code=#{code}]").addClass "active"
    @render()

  _bind: ->
    @list.on "click", "a", @_onClickListItem
    @ref.on "click", (e) =>
      @show()
      @context.showPopover()
      false

  _onClickListItem: (e) =>
    $item = $(e.currentTarget)
    @list.find("a").removeClass 'active'
    $item.addClass('active')

    @selectByCode $item.data('code')

    unless @field.length > 0
      @context.hidePopover()
      return false

    @context.afterSelect(@type)
    false

  selectByCode: (code) ->
    @current = @dataMap[code]
    @ref.text(@current.name).show()
    @field.val @current.code
    @

  reset: ->
    @field.val null
    @ref.text("").hide()
    @

  show: ->
    @context.el.find(".district-list").hide()
    @list.show()
    @

  setCodes: (codes) ->
    @codes = codes
    @

  isSelected: ->
    !!@field.val()

  render: ->
    @list.find('dd').empty()
    @codes = Object.keys(@dataMap) if @codes == "all"
    for code in @codes
      data = @dataMap[code]
      $("""
        <a title='#{data.name}' data-code='#{code}' href='javascript:;'>
          #{data.name}
        </a>
      """).appendTo @list.find('dd')
    if curCode = @current?.code
      @list.find("[data-code=#{curCode}]").addClass "active"

    @

module.exports = Controller
