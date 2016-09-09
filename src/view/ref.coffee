class Ref extends QingModule
  constructor: ->
    @el = $('<a class="district-item" href="javascript:;"></a>').hide()
    @el.on "click", (e) =>
      @trigger "visit", [$(e.currentTarget).data("code")]

  linkTo: (item) ->
    @el.text(item.name).data("code", item.code).show()

  reset: ->
    @el.text("").hide()

module.exports = Ref
