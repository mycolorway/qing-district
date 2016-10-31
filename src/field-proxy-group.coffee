class FieldProxyGroup extends QingModule

  opts:
    wrapper: null
    placeholder: null

  _init: ->
    @el = $("""
      <div class="district-field-proxy-group">
        <a class="placeholder">#{@opts.placeholder}</a>
      </div>
    """).appendTo @opts.wrapper
    @setEmpty true

  isEmpty: ->
    @el.is ".empty"

  setEmpty: (empty) ->
    @el.toggleClass "empty", empty

module.exports = FieldProxyGroup
