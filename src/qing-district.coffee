DataStore = require "./data-store.coffee"
Popover = require "./view/popover.coffee"
Controller = require "./controller.coffee"

class QingDistrict extends QingModule

  @opts:
    el: null
    dataSource: null

  @_tpl: '''
    <div class="qing-district-wrapper">
      <div class="district-info empty">
        <span class="placeholder">点击选择城市</span>
      </div>
    </div>
  '''

  constructor: (opts) ->
    super
    @opts = $.extend {}, QingDistrict.opts, @opts
    @el = $ @opts.el

    unless @el.length > 0
      throw new Error 'QingDistrict: option el is required'
    unless $.isFunction(@opts.dataSource)
      throw new Error 'QingDistrict: option dataSource is required'

    @_render()
    @popover = new Popover
      target: @el
      wrapper: @wrapper

    @opts.dataSource.call null, (data) =>
      @dataStore = new DataStore(data)

      @register new Controller(
        target: @el,
        dataStore: @dataStore,
        type: "province",
        codes: "all"
      )
      @register new Controller(
        target: @el,
        dataStore: @dataStore,
        type: "city"
      )
      @register new Controller(
        target: @el,
        dataStore: @dataStore,
        type: "county"
      )

      @_bind()

      for type in ["province", "city", "county"]
        controller = @controllers[type]
        if controller.isSelected()
          controller.trigger "afterSelect", [controller, true]

      @setInfoBarActive(true) if @isFullFilled()

      @trigger 'ready'

  isFullFilled: ->
    for type in ["province", "city", "county"]
      return false unless @controllers[type].isSelected()
    true

  register: (controller) ->
    @el.find(".district-info").append controller.ref.el
    @popover.el.append controller.listView.el
    @controllers ||= {}
    @controllers[controller.type] = controller

  setInfoBarActive: (active) ->
    @wrapper.find('.district-info').toggleClass "empty", !active

  _render: ->
    @wrapper = $(QingDistrict._tpl).data('district', @).prependTo @el
    @el.addClass ' qing-district'
      .data 'qingDistrict', @

  _bind: ->
    @wrapper
      .on 'click', '.district-info', =>
        if @wrapper.hasClass 'active'
          @popover.setActive(false)
        else
          @controllers.province.render()
          @popover.setActive(true)

    @popover
      .on "show", ->
        @wrapper.addClass "active"
      .on "hide", =>
        @wrapper.removeClass "active"
        unless @isFullFilled()
          for type, controller of @controllers
            controller.reset()
            @setInfoBarActive(false)

    @controllers.province
      .on "afterSelect", (e, province, init) =>
        @setInfoBarActive(true) unless init
        codes = province.current.cities
        city = @controllers.city
        if codes.length == 1 &&
            city.dataMap[codes[0]].name == province.current.name
          city.reset().selectByCode(codes[0]).ref.el.hide()
          city.trigger "afterSelect", city unless init
        else
          city.reset() unless init
          city.setCodes(codes).render()
        @controllers.county.reset() unless init
      .on "visit", (e) =>
        @controllers.city.listView.hide()
        @controllers.county.listView.hide()
        @popover.setActive(true)

    @controllers.city
      .on "afterSelect", (e, city, init) =>
        @setInfoBarActive(true) unless init
        codes = city.current.counties
        @controllers.county.reset() unless init
        @controllers.county.setCodes(codes).render()
      .on "visit", (e) =>
        @controllers.province.listView.hide()
        @controllers.county.listView.hide()
        @popover.setActive true

    @controllers.county
      .on "afterSelect", (e, county, init) =>
        @setInfoBarActive(true) unless init
        @popover.setActive(false)
      .on "visit", (e) =>
        @controllers.province.listView.hide()
        @controllers.city.listView.hide()
        @popover.setActive true

  destroy: ->
    @el.empty()
      .removeData 'qingDistrict'

module.exports = QingDistrict
