class FieldProxyGroup extends QingModule
  opts:
    wrapper: null

  constructor: ->
    super
    @el = $("""
      <div class="district-field-proxy-group">
        <span class="placeholder">点击选择城市</span>
      </div>
    """).appendTo @opts.wrapper
    @_bind()
    @setEmpty true

  _bind: ->
    @el.on "click", ".placeholder", =>
      @trigger "emptySelect"

  setEmpty: (empty) ->
    @el.toggleClass "empty", empty

module.exports = FieldProxyGroup
