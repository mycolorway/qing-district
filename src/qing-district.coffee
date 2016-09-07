class QingDistrict extends QingModule

  @opts:
    el: null

  constructor: (opts) ->
    super

    @el = $ @opts.el
    unless @el.length > 0
      throw new Error 'QingDistrict: option el is required'

    @opts = $.extend {}, QingDistrict.opts, @opts
    @_render()
    @trigger 'ready'

  _render: ->
    @el.append """
      <p>This is a sample component.</p>
    """
    @el.addClass ' qing-district'
      .data 'qingDistrict', @

  destroy: ->
    @el.empty()
      .removeData 'qingDistrict'

module.exports = QingDistrict
