List = require '../src/list.coffee'
DataStore = require '../src/data-store.coffee'
rawData = require './fixtures/data.js'
expect = chai.expect

describe 'List', ->

  $wrapper = null
  list = null
  data = (new DataStore()).formatData(rawData)

  before ->
    $wrapper = $ "<div></div>"
      .appendTo 'body'

  after ->
    $wrapper.remove()
    $wrapper = null

  beforeEach ->
    list = new List
      wrapper: $wrapper
      data: data.province

  describe "initialize", ->
    it "append ui", ->
      expect($wrapper.html()).not.to.be.empty

    it "should not render without codes", ->
      expect(list.el.find("dd").html()).to.be.empty

    it "should be hidden for there is no codes", ->
      expect(list.el.is(':visible')).to.be.false

  describe 'render', ->
    it "should render with `all` as codes", ->
      list.setCodes('all').render()
      expect(list.el.find("dd a")).not.to.be.empty

    it "should show after rendering", ->
      expect(list.el.is(':visible')).to.be.false
      list.setCodes('all').render()
      expect(list.el.is(':visible')).to.be.true

  describe "highlightItem", ->

    beforeEach ->
      list.setCodes('all').render()

    it "should not highlight any without argument", ->
      list.highlightItem()
      item = data.province['110000']
      expect list.el.find("dd a.active").length
        .to.equal 0

    it "should highlight one", ->
      item = data.province['110000']
      list.highlightItem(item)
      expect list.el.find("a[data-code=#{item.code}]").is(".active")
        .to.be.true

  describe "on select", ->

    beforeEach ->
      list.setCodes('all').render()

    it "should set current", ->
      list.el.find('a:first').trigger 'click'
      expect(list.current).not.to.undefined

    it "should hide", ->
      list.el.find('a:first').trigger 'click'
      expect(list.el.is(':visible')).to.be.false

    it "should trigger `select` with item", ->
      callback = sinon.spy()
      list.on "select", callback
      list.el.find('a:first').trigger 'click'
      expect callback.called
        .to.be.true
