class List extends QingModule

  opts:
    wrapper: null
    data: null
    codes: []

  constructor: ->
    super
    { @wrapper, @data, @codes } = @opts

    @el = $("""
      <div class="district-list">
        <dl><dd></dd></dl>
      </div>
    """).hide().appendTo @wrapper

    @render()
    @_bind()

  highlightItem: (item) ->
    @el.find("a").removeClass "active"
    @el.find("[data-code=#{item.code}]").addClass "active" if item

  show: ->
    @el.show()
    @trigger("show")

  hide: ->
    @el.hide()
    @trigger("hide")

  _bind: ->
    @el.on "click", "a", (e) =>
      $item = $(e.currentTarget)
      @setCurrent @data[$item.data("code")]
      @hide()
      @trigger "afterSelect", [@current]
      false

  setCurrent: (item) ->
    @highlightItem @current = item
    @

  setCodes: (codes) ->
    @codes = codes
    @

  render: ->
    @codes = Object.keys(@data) if @codes == "all"
    return unless @codes
    @el.find('dd').empty()
    for code in @codes
      item = @data[code]
      $("""
        <a data-code='#{item.code}' tabindex='-1' href='javascript:;'>
          #{item.name}
        </a>
      """).appendTo @el.find('dd')
    @highlightItem @data[@current?.code]
    @show()
    @

module.exports = List
