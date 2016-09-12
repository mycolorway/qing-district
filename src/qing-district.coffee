DataStore = require "./data-store.coffee"
Popover = require "./popover.coffee"
FieldProxy = require "./field-proxy.coffee"
FieldProxyGroup = require "./field-proxy-group.coffee"
List = require "./list.coffee"

class QingDistrict extends QingModule

  @opts:
    el: null
    dataSource: null
    locales:
      placeholder: "Click to select"

  constructor: (opts) ->
    super
    @el = $ @opts.el

    unless @el.length > 0
      throw new Error 'QingDistrict: option el is required'

    if initialized = @el.data("qingDistrict")
      return initialized

    unless $.isFunction(@opts.dataSource)
      throw new Error 'QingDistrict: option dataSource is required'

    $.extend @opts, QingDistrict.opts, opts
    @locales = @opts.locales || QingDistrict.locales

    @dataStore = new DataStore()
    @dataStore.on "loaded", (e, data) =>
      @_render()
      @_init(data)
      @_bind()
      @_restore()
      @trigger 'ready'
    @dataStore.load @opts.dataSource

  _render: ->
    @wrapper = $("""
      <div class="qing-district-wrapper"></div>
    """).data('district', @).prependTo @el
    @el.addClass ' qing-district'
      .data 'qingDistrict', @

  _init: (data) ->
    @popover = new Popover
      target: @el
      wrapper: @wrapper

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
    @fieldGroup.on "emptySelect", =>
      @cityList.hide()
      @countyList.hide()
      @provinceList.render()
      @popover.setActive(true)

    @popover
      .on "show", =>
        @wrapper.addClass "active"
      .on "hide", =>
        @wrapper.removeClass "active"
        @_hideAllExcpet("none")
        unless @isFullFilled()
          @provinceList.setCurrent(null)
          @provinceField.clear()
          @cityField.clear()
          @countyField.clear()
          @fieldGroup.setEmpty(true)

    @provinceField.on "active", (e, item) =>
      @_hideAllExcpet("province")
      @provinceList.setCurrent(item).show() if item
      @popover.setActive(true)
    @provinceList.on "afterSelect", (e, province) =>
      @fieldGroup.setEmpty(false)
      @provinceField.setItem province
      firstCity = @cityList.data[province.cities[0]]
      if @_isMunicipality(province, firstCity)
        @cityList.setCurrent(firstCity).hide()
        @cityList.trigger "afterSelect", @cityList.current
        @cityField.setActive(false)
      else
        @cityList.setCodes(province.cities).render()
        @cityField.clear().setActive(true)
        @countyField.clear()

    @cityField
      .on "active", (e, item) =>
        @_hideAllExcpet("city")
        @cityList.setCurrent(item).show() if item
        @popover.setActive true
      .on "restore", =>
        @cityList.setCodes(@provinceField.getItem().cities).render()
    @cityList.on "afterSelect", (e, city) =>
      @fieldGroup.setEmpty(false)
      @cityField.setItem(city)
      @countyList.setCodes(city.counties).render()
      @countyField.clear().setActive(true, true)

    @countyField
      .on "active", (e, item) =>
        @_hideAllExcpet("county")
        @countyList.setCurrent(item).show() if item
        @popover.setActive true
      .on "restore", =>
        @countyList.setCodes(@cityField.getItem().counties).render()
    @countyList.on "afterSelect", (e, county) =>
      @fieldGroup.setEmpty(false)
      @countyField.setItem(county).highlight(false)
      @popover.setActive(false)

  _restore: ->
    @provinceField.restore()
    @cityField.restore()
    if @_isMunicipality(@provinceField.getItem(), @cityField.getItem())
      @cityField.setActive(false)
    @countyField.restore()
    @fieldGroup.setEmpty(false) if @isFullFilled()

  _isMunicipality: (province, city) ->
    return false unless province and city
    province.cities.length == 1 && city.name == province.name

  _hideAllExcpet: (type) ->
    for _type in ["province", "city", "county"]
      if _type != type
        @["#{_type}List"].hide()
        @["#{_type}Field"].highlight(false)

  isFullFilled: ->
    @provinceField.isFilled() &&
    @cityField.isFilled() &&
    @countyField.isFilled()

  destroy: ->
    @popover.destroy()
    @wrapper.remove()
    @el.removeClass "qing-district"
      .removeData 'qingDistrict'

module.exports = QingDistrict
