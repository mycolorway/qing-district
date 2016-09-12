FieldProxy = require "../src/field-proxy.coffee"
FieldProxyGroup = require "../src/field-proxy-group.coffee"
DataStore = require "../src/data-store.coffee"
rawData = require "./fixtures/data.js"

assert = chai.assert

describe "FieldProxy", ->

  $wrapper = null
  $field = null
  group = null
  field = null
  data = (new DataStore()).formatData(rawData)

  before ->
    $wrapper = $ "<div></div>"
      .appendTo 'body'
    $field = $('<input type="hidden" name="province" data-province-field value="110000" />')
      .appendTo $wrapper
    group = new FieldProxyGroup
      wrapper: $wrapper

  beforeEach ->
    field = new FieldProxy
      group: group,
      data: data.province
      field: $field

  describe "initialize", ->
    it "should attend el", ->
      assert.equal 1, $wrapper.find(field.el).length

    it "should be hidden", ->
      assert.equal false, field.el.is(":visible")

  it "highlight", ->
    field.highlight(true)
    assert field.el.is(".active")
    field.highlight(false)
    assert.isNotOk field.el.is(".active")

  it "setItem", ->
    item = data.province["110000"]
    field.setItem(item)
    assert.equal item.name, field.el.text()
    assert.equal item.code, field.field.val()

  it "clear", ->
    item = data.province["110000"]
    field.setItem(item)
    field.clear()
    assert.equal "", field.el.text()
    assert.equal null, field.getItem()

  describe "restore", ->

    it "will trigger restore event with init value", ->
      spy = sinon.spy()
      field.on "restore", spy
      field.field.val("110000")
      field.restore()
      assert spy.called

    it "will not trigger restore", ->
      spy = sinon.spy()
      field.on "restore", spy
      field.field.val null
      field.restore()
      assert.isNotOk spy.called

  it "isFilled", ->
    field.field.val null
    assert.isNotOk field.isFilled()
    field.field.val "110000"
    assert field.isFilled()

  describe "setActive", ->

    it "set placeholder", ->
      field.el.text ""
      field.setActive(true)
      assert.equal "_", field.el.text()

    it "should be highlight", ->
      spy = sinon.spy field, "highlight"
      field.setActive true
      assert spy.calledWith(true)
      field.setActive false
      assert spy.calledWith(false)

    it "should trigger active event", ->
      spy = sinon.spy()
      field.on "active", spy
      field.setActive true
      assert spy.called
      spy.reset()
      field.setActive false
      assert.isNotOk spy.called
