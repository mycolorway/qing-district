class Popover extends QingModule

  opts:
    id: null
    target: null
    wrapper: null

  @instanceCount: 0

  _init: ->
    @wrapper = $ @opts.wrapper
    @target = $ @opts.target
    @el = $('<div class="district-popover"></div>').hide().appendTo @wrapper
    @id = ++ Popover.instanceCount
    @el.on "keydown", (e) =>
      if e.which == 27
        @setActive(false)

  setActive: (active) ->
    if active then @_show() else @_hide()

  _show: ->
    return if @el.is(":visible")
    @el.show()
    $(document).off("click.qing-district-#{@id}").on "click.qing-district-#{@id}", (e) =>
      $target = $(e.target)
      return unless @wrapper.hasClass('active')
      return if @target.has($target).length or $target.is(@target)
      @_hide()
    @trigger "show"

  _hide: ->
    return unless @el.is(":visible")
    $(document).off(".qing-district-#{@id}")
    @el.hide()
    @trigger "hide"

  destroy: ->
    @setActive(false)
    $(document).off(".qing-district-#{@id}")
    @el.remove()

module.exports = Popover
