QingDistrict = require '../src/qing-district.coffee'
rawData = require './fixtures/data.js'
assert = chai.assert

describe 'QingDistrict', ->

  $el = null
  qingDistrict = null
  data = null

  before ->
    $el = $("""
    <div class="test-el">
      <input type="hidden" name="province" data-province-field value="110000" />
      <input type="hidden" name="city" data-city-field value ="110100" />
      <input type="hidden" name="county" data-county-field value= "110105" />
    </div>
    """).appendTo 'body'

  after ->
    $el.remove()
    $el = null

  beforeEach ->
    qingDistrict = new QingDistrict
      el: '.test-el'
      dataSource: (callback) ->
        callback(rawData)
    data ||= qingDistrict.dataStore.data

  afterEach ->
    qingDistrict.destroy()
    qingDistrict = null

  it "should not initialize twice", ->
    instanceOne = new QingDistrict
      el: '.test-el'
    instanceTwo = new QingDistrict
      el: '.test-el'
    assert.equal qingDistrict, instanceOne
    assert.equal qingDistrict, instanceTwo

  it 'should throw error when element not found', ->
    spy = sinon.spy QingDistrict
    try
      new spy
        el: '.not-exists'
    catch e
    assert spy.calledWithNew()
    assert spy.threw()

  it "_hideAllExcpet", ->
    listHide = sinon.spy qingDistrict.cityList, "hide"
    fieldHighlight = sinon.spy qingDistrict.cityField, "highlight"
    qingDistrict._hideAllExcpet("province")
    assert listHide.called
    assert fieldHighlight.calledWith(false)

  describe "isFullFilled", ->
    it "is right", ->
      for type in ["province", "city", "county"]
        sinon.stub qingDistrict["#{type}Field"], "isFilled"
          .returns true
      assert qingDistrict._isFullFilled()

    it "is wrong", ->
      for type in ["province", "county"]
        sinon.stub qingDistrict["#{type}Field"], "isFilled"
          .returns true
      sinon.stub qingDistrict.cityField, "isFilled"
        .returns false
      assert.isNotOk qingDistrict._isFullFilled()

  describe "_isMunicipality", ->
    it "is right", ->
      province = data.province["110000"]
      city = data.city[province.cities[0]]
      assert qingDistrict._isMunicipality(province, city)

    it "is wrong", ->
      province = data.province["440000"]
      city = data.city[province.cities[0]]
      assert.isNotOk qingDistrict._isMunicipality(province, city)

  describe "Popover", ->
    it "on show", ->
      qingDistrict.popover.trigger "show"
      assert qingDistrict.wrapper.hasClass "active"

    it "on hide", ->
      hideAllSpy = sinon.spy qingDistrict, "_hideAllExcpet"
      qingDistrict.popover.trigger "hide"
      assert.isNotOk qingDistrict.wrapper.hasClass "active"
      assert hideAllSpy.calledWith "none"

    it "clear all fields if it's not full fielded", ->
      spies = []
      sinon.stub(qingDistrict, '_isFullFilled').returns false
      for type in ["province", "city", "county"]
        spies.push sinon.spy qingDistrict["#{type}Field"], "clear"
      qingDistrict.popover.trigger "hide"
      assert spy.called for spy in spies

  describe "Field provies active", ->

    it "province field on active without item", ->
      hideAllSpy = sinon.spy qingDistrict, "_hideAllExcpet"
      for type in ["province", "city", "county"]
        listSpy = sinon.spy qingDistrict["#{type}List"], "setCurrent"
        qingDistrict["#{type}Field"].trigger "active"
        assert hideAllSpy.calledWith "province"
        assert.isNotOk listSpy.called

    it "province field on active with item", ->
      item = data.province["110000"]
      for type in ["province", "city", "county"]
        listSpy = sinon.spy qingDistrict["#{type}List"], "setCurrent"
        qingDistrict["#{type}Field"].trigger "active", [item]
        assert listSpy.calledWith item
        assert qingDistrict["#{type}List"].el.is(":visible")

  describe "After select", ->

    it "municipality province", ->
      fieldSpy = sinon.spy qingDistrict.provinceField, "setItem"
      citySpy = sinon.spy()
      qingDistrict.cityList.on "afterSelect", citySpy
      cityFieldSpy = sinon.spy qingDistrict.cityField, "setActive"

      item = data.province["110000"]
      qingDistrict.provinceList.trigger "afterSelect", [item]
      assert fieldSpy.calledWith item
      assert citySpy.called
      assert cityFieldSpy.calledWith false
      assert.isNotOk qingDistrict.cityList.el.is(":visible")

    it "normal province", ->
      cityListSpy = sinon.spy qingDistrict.cityList, "render"
      cityFieldClearSpy = sinon.spy qingDistrict.cityField, "clear"
      countyFieldClearSpy = sinon.spy qingDistrict.countyField, "clear"

      item = data.province["440000"]
      qingDistrict.provinceList.trigger "afterSelect", [item]
      assert cityListSpy.called
      assert cityFieldClearSpy.called
      assert countyFieldClearSpy.called

  describe "restore", ->

    it "on restore", ->
      for type, content of {
        city: ["province", "110000", "110100", "cities"],
        county: ["city", "110100", "110105", "counties"]
      }
        setCodesSpy = sinon.spy qingDistrict["#{type}List"], "setCodes"
        renderSpy = sinon.spy qingDistrict["#{type}List"], "render"

        item = data[content[0]][content[1]]
        qingDistrict["#{content[0]}Field"].setItem item
        qingDistrict["#{type}Field"].field.val content[2]

        qingDistrict["#{type}Field"].restore()
        assert setCodesSpy.calledWith item[content[3]]
        assert renderSpy.called

    it "restore municipality", ->
      sinon.stub(qingDistrict, "_isMunicipality").returns true
      citySetActiveSpy = sinon.spy qingDistrict.cityField, "setActive"
      qingDistrict._restore()
      assert citySetActiveSpy.calledWith false

  describe "FieldProxyGroup", ->
    it 'should response to emptySelect event', ->
      spies = [
        sinon.spy(qingDistrict.cityList, "hide"),
        sinon.spy(qingDistrict.countyList, "hide"),
        sinon.spy(qingDistrict.provinceList, "render")
      ]
      popoverSetActive = sinon.spy qingDistrict.popover, "setActive"
      qingDistrict.fieldGroup.trigger "emptySelect"
      for spy in spies
        assert spy.called
      assert popoverSetActive.calledWith true

  it "destroy", ->
    qingDistrict.destroy()
    assert.isNotOk qingDistrict.el.hasClass(".qing-district")
    assert.isUndefined qingDistrict.el.data("qingDistrict")
    assert.equal 0, $el.find(qingDistrict.wrapper).length

require './list.coffee'
require './data-store.coffee'
require './popover.coffee'
require './field-proxy.coffee'
require './field-proxy-group.coffee'
