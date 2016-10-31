Popover = require '../src/popover.coffee'
assert = chai.assert

describe 'Popover', ->
  $target = null
  $appendTo = null
  popover = null

  before ->
    $target = $ "<div></div>"
      .appendTo 'body'
    $appendTo = $ "<div></div>"
      .appendTo $target

  beforeEach ->
    popover = new Popover
      target: $target
      appendTo: $appendTo

  describe "initialize", ->

    it "append to body by default", ->
      popover = new Popover
        target: $target
      assert.equal 1, $('body').find(popover.el).length

    it "should append el", ->
      assert.equal 1, $appendTo.find(popover.el).length

    it "should be hidden", ->
      setTimeout ->
        assert.equal false, popover.el.is(':visible')

  describe "destroy", ->

    it "remove el", ->
      popover.destroy()
      assert.equal 0, $appendTo.find(popover.el).length

    it "off event", ->
      spy = sinon.spy()
      $(document).on "test.qing-district-popover-#{popover.id}", spy

      $(document).trigger "test.qing-district-popover-#{popover.id}"
      assert spy.called

      spy.reset()
      popover.destroy()
      $(document).trigger "test.qing-district-popover#{popover.id}"
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
