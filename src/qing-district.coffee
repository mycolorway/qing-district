Util = require "./util.coffee"
Controller = require "./controller.coffee"

class QingDistrict extends QingModule

  @opts:
    el: null
    dataSource: null

  @_tpl: '''
    <div class="qing-district">
      <div class="district-info empty">
        <span class="placeholder">点击选择城市</span>
      </div>
      <div class="district-popover">
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

    @opts.dataSource.call null, (data) =>
      @data = Util.normalizeData(data)

      @_render()
      @_bind()

      @register new Controller(@, "province", "all")
      @register new Controller(@, "city")
      @register new Controller(@, "county")
      for type in ["province", "city", "county"]
        @afterSelect type, true if @controllers[type].isSelected()

      @resetSelectedInfoStatus(true) if @isFullFilled()
      @trigger 'ready'

  isFullFilled: ->
    for type in ["province", "city", "county"]
      return false unless @controllers[type].isSelected()
    true

  register: (controller) ->
    @el.find(".district-info").append controller.ref
    @el.find(".district-popover").append controller.list
    @controllers ||= {}
    @controllers[controller.type] = controller

  resetSelectedInfoStatus: (isEmpty) ->
    @selectEl.find('.district-info').toggleClass "empty", !isEmpty

  afterSelect: (type, init=false) ->
    @resetSelectedInfoStatus(true) unless init
    switch type
      when "province"
        curProvice = @controllers.province.current
        codes = curProvice.cities
        cityCtrl = @controllers.city
        if codes.length == 1 &&
            cityCtrl.dataMap[codes[0]].name == curProvice.name
          cityCtrl.reset().selectByCode(codes[0]).ref.hide()
          @afterSelect("city") unless init
        else
          cityCtrl.reset() unless init
          cityCtrl.setCodes(codes).render(true).show()
        @controllers.county.reset() unless init
      when "city"
        codes = @controllers.city.current.counties
        @controllers.county.reset() unless init
        @controllers.county.setCodes(codes).render(true).show()
      else
        @hidePopover()

  _render: ->
    @selectEl = $(QingDistrict._tpl).data('district', @).prependTo @el
    @el.addClass ' qing-district'
      .data 'qingDistrict', @

  _bind: ->
    @selectEl
      .on 'click', '.district-info', =>
        if @selectEl.hasClass 'active'
          @hidePopover()
        else
          @controllers.province.show()
          @showPopover()

  showPopover: ->
    @selectEl.addClass 'active'

    $(document).off('click.qing-district').on 'click.qing-district', (e) =>
      $target = $(e.target)
      return unless @selectEl.hasClass('active')
      return if @el.has($target).length or $target.is(@el)
      @hidePopover()

    @trigger("showPopover")

  hidePopover: ->
    @selectEl.removeClass 'active'
    $(document).off('.qing-district')
    @trigger("hidePopover")
    unless @isFullFilled()
      for type, controller of @controllers
        controller.reset()
        @resetSelectedInfoStatus(false)

  destroy: ->
    @el.empty()
      .removeData 'qingDistrict'

module.exports = QingDistrict
