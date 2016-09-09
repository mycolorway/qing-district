class Popover extends QingModule

  opts:
    target: null
    wrapper: null

  constructor: ->
    super
    @wrapper = $ @opts.wrapper
    @target = $ @opts.target
    @el = $('<div class="district-popover"></div>').appendTo @wrapper

  setActive: (active) ->
    if active then @_show() else @_hide()

  _show: ->
    @el.show()
    $(document).off('click.qing-district').on 'click.qing-district', (e) =>
      $target = $(e.target)
      return unless @wrapper.hasClass('active')
      return if @target.has($target).length or $target.is(@target)
      @_hide()
    @trigger "show"

  _hide: ->
    $(document).off('.qing-district')
    @el.hide()
    @trigger "hide"

module.exports = Popover
