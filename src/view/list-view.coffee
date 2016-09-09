class ListView extends QingModule

  constructor: ->
    super

    @el = $("""
      <div class="district-list">
        <dl><dd></dd></dl>
      </div>
    """).hide()

    @el.on "click", "a", (e) =>
      $item = $(e.currentTarget)
      @trigger "select", [$item.data("code")]

  highlightItem: (item) ->
    return unless item
    @el.find("a").removeClass "active"
    @el.find("[data-code=#{item.code}]").addClass "active"

  show: ->
    @el.show()

  hide: ->
    @el.hide()

  render: (items) ->
    @el.find('dd').empty()
    for item in items
      $("""
        <a title='#{item.name}' data-code='#{item.code}' href='javascript:;'>
          #{item.name}
        </a>
      """).appendTo @el.find('dd')

module.exports = ListView
