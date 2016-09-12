Popover = require '../src/popover.coffee'
assert = chai.assert

describe 'Popover', ->
  $target = null
  $wrapper = null
  popover = null

  before ->
    $target = $ "<div></div>"
      .appendTo 'body'
    $wrapper = $ "<div></div>"
      .appendTo $target

  beforeEach ->
    popover = new Popover
      target: $target
      wrapper: $wrapper

  describe "initialize", ->

    it "shoulde append el", ->
      assert.equal 1, $wrapper.find(popover.el).length

    it "should be hidden", ->
      assert.equal false, popover.el.is(':visible')

  describe "destroy", ->

    it "remove el", ->
      popover.destroy()
      assert.equal 0, $wrapper.find(popover.el).length

    it "off event", ->
      spy = sinon.spy()
      $(document).on "test.qing-district", spy

      $(document).trigger "test.qing-district"
      assert spy.called

      spy.reset()
      popover.destroy()
      $(document).trigger "test.qing-district"
      assert.equal false, spy.called

  describe "setActive", ->

    it "should show", ->
      popover.setActive(true)
      assert popover.el.is(":visible")

    it "should trigger show or hide event", ->
      spy = sinon.spy()
      popover
        .on "show", spy
        .on "hide", spy
      popover.setActive(true)
      popover.setActive(false)
      assert spy.calledTwice

    it "should not show or hide twice", ->
      spy = sinon.spy()
      popover
        .on "show", spy
        .on "hide", spy
      popover.setActive(true)
      popover.setActive(true)
      assert spy.calledOnce

      spy.reset()
      popover.setActive(false)
      popover.setActive(false)
      assert spy.calledOnce
