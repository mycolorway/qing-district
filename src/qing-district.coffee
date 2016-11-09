DataStore = require "./data-store.coffee"
Popover = require "./popover.coffee"
FieldProxy = require "./field-proxy.coffee"
FieldProxyGroup = require "./field-proxy-group.coffee"
List = require "./list.coffee"

class QingDistrict extends QingModule

  @name: "QingDistrict"

  @opts:
    el: null
    dataSource: null
    renderer: null
    popoverAppendTo: 'body'
    popoverOffset: 12

  @locales:
    placeholder: "Click to select"

  @instanceCount: 0

  @isMunicipality: (province, city) ->
    return false unless province and city
    province.cities.length == 1 && city.name == province.name

  _setOptions: (opts) ->
    super
    $.extend @opts, QingDistrict.opts, opts

  _init: (opts) ->
    super
    @el = $ @opts.el

    unless @el.length > 0
      throw new Error 'QingDistrict: option el is required'

    if initialized = @el.data("qingDistrict")
      return initialized

    unless $.isFunction(@opts.dataSource)
      throw new Error 'QingDistrict: option dataSource is required'

    @locales = $.extend {}, QingDistrict.locales, @opts.locales
    @id = ++ QingDistrict.instanceCount

    @_render()

    @dataStore = new DataStore()
    @dataStore.on "loaded", (e, data) =>
      @_setup(data)
      @_bind()
      @_restore()
      if $.isFunction @opts.renderer
        @opts.renderer.call @, @wrapper, @
      @trigger 'ready'
    @dataStore.load @opts.dataSource

  _render: ->
    @wrapper = $("""
      <div class="qing-district-wrapper"></div>
    """).data('district', @)
        .prependTo @el

    @el.attr('tabindex', 0)
      .addClass ' qing-district'
      .data 'qingDistrict', @

  _setup: (data) ->
    @popover = new Popover
      target: @el
      appendTo: @opts.popoverAppendTo
      offset: @opts.popoverOffset

    @provinceList = new List
      wrapper: @popover.el,
      data: data.province,
      codes: "all"
    @cityList = new List
      wrapper: @popover.el,
      data: data.city,
    @countyList = new List
      wrapper: @popover.el,
      data: data.county,

    @fieldGroup = new FieldProxyGroup
      wrapper: @wrapper
      placeholder: @locales.placeholder

    @provinceField = new FieldProxy
      group: @fieldGroup,
      data: data.province
      field: @el.find("[data-province-field]")
    @cityField = new FieldProxy
      group: @fieldGroup,
      data: data.city,
      field: @el.find("[data-city-field]")
    @countyField = new FieldProxy
      group: @fieldGroup,
      data: data.county,
      field: @el.find("[data-county-field]")

  _bind: ->
    @el.on "keydown", (e) =>
      return unless $(e.target).is(@el)
      switch e.which
        when 13, 40
          @fieldGroup.el.trigger "click"
        when 27
          @popover.setActive(false)

    @fieldGroup.el.on "click", =>
      if @popover.active
        @popover.setActive false
      else if @fieldGroup.isEmpty()
        @cityList.hide()
        @countyList.hide()
        @provinceList.render()
        @popover.setActive true
      else
        @provinceField.setActive true

    @popover
      .on "show", =>
        @wrapper.addClass "active"
        @el.addClass "active"
      .on "hide", =>
        @wrapper.removeClass "active"
        @el.removeClass "active"
        @_hideAllExcpet("none")
        unless @_isFullFilled()
          @provinceList.setCurrent(null)
          @provinceField.clear()
          @cityField.clear()
          @countyField.clear()
          @fieldGroup.setEmpty(true)

    @provinceField.on "active", (e, item) =>
      @_hideAllExcpet("province")
      @provinceList.setCurrent(item).show() if item
      @popover.setActive(true)
    @provinceList.on "select", (e, province) =>
      @fieldGroup.setEmpty(false)
      @provinceField.setItem(province).highlight(false)
      firstCity = @cityList.data[province.cities[0]]
      if @_isMunicipality(province, firstCity)
        @cityList.setCurrent(firstCity).hide()
        @cityList.trigger "select", @cityList.current
        @cityField.setActive(false)
      else
        @cityList.setCodes(province.cities).render()
        @cityField.clear()
        @countyField.clear()

    @cityField
      .on "active", (e, item) =>
        @_hideAllExcpet("city")
        @cityList.setCurrent(item).show() if item
        @popover.setActive true
      .on "restore", =>
        @cityList.setCodes(@provinceField.getItem().cities).render()
    @cityList.on "select", (e, city) =>
      @fieldGroup.setEmpty(false)
      @cityField.setItem(city).highlight(false)
      @countyField.clear()
      if city.counties.length == 0
        @popover.setActive false
      else
        @countyList.setCodes(city.counties).render()

    @countyField
      .on "active", (e, item) =>
        @_hideAllExcpet("county")
        @countyList.setCurrent(item).show() if item
        @popover.setActive true
      .on "restore", =>
        @countyList.setCodes(@cityField.getItem().counties).render()
    @countyList.on "select", (e, county) =>
      @fieldGroup.setEmpty(false)
      @countyField.setItem(county).highlight(false)
      @popover.setActive(false)

  _restore: ->
    @provinceField.restore()
    @cityField.restore()
    if @_isMunicipality(@provinceField.getItem(), @cityField.getItem())
      @cityField.setActive(false)
    @countyField.restore()
    @fieldGroup.setEmpty(false) if @_isFullAny()

  _isMunicipality: (province, city) ->
    QingDistrict.isMunicipality province, city

  _hideAllExcpet: (type) ->
    for _type in ["province", "city", "county"]
      if _type != type
        @["#{_type}List"].hide()
        @["#{_type}Field"].highlight(false)

  _isFullFilled: ->
    filled = @provinceField.isFilled() && @cityField.isFilled()
    if filled && @cityField.getItem().counties.length == 0
      filled
    else
      filled && @countyField.isFilled()

  _isFullAny: ->
    @provinceField.isFilled() ||
    @cityField.isFilled() ||
    @countyField.isFilled()

  destroy: ->
    @popover.destroy()
    @wrapper.remove()
    @el.removeClass "qing-district"
      .removeData 'qingDistrict'

QingDistrict.DataStore = DataStore
QingDistrict.List = List

module.exports = QingDistrict
