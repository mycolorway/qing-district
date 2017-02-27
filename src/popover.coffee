class Popover extends QingModule

  opts:
    target: null
    appendTo: null
    offset: null

  @instanceCount: 0

  _init: ->
    @target = $ @opts.target
    @el = $('<div class="qing-district-popover"></div>')
      .appendTo @opts.appendTo || @target
    @id = ++ Popover.instanceCount
    @active = false
    @_bind()

  _bind: ->
    $(document).on "click.qing-district-popover-#{@id}", (e) =>
      return if $(e.target).is(@el) ||
        $.contains(@el[0], e.target) ||
        $.contains(@target[0], e.target)
      @setActive false
      null

  setActive: (active) ->
    return if @target.hasClass('disabled')
    return if active == @active

    if active
      @el.addClass('active')
        .appendTo @opts.appendTo

      @el.css width: @target.width()
      @resetPosition()
      @trigger 'show'
    else
      @el.removeClass('active')
        .detach()
      @trigger 'hide'

    @active = active
    @

  resetPosition: ->
    inputOffset = @target.offset()
    wrapperOffset = @el.offsetParent().offset()
    offsetTop = inputOffset.top - wrapperOffset.top
    offsetLeft = inputOffset.left - wrapperOffset.left
    @el.css
      top: offsetTop + @target.outerHeight() + @opts.offset
      left: offsetLeft || 0

  destroy: ->
    @setActive(false)
    $(document).off(".qing-district-popover-#{@id}")
    @el.remove()

module.exports = Popover
