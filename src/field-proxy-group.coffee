class FieldProxyGroup extends QingModule
  opts:
    wrapper: null
    placeholder: null

  constructor: ->
    super
    @el = $("""
      <div class="district-field-proxy-group">
        <a class="placeholder">#{@opts.placeholder}</a>
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
