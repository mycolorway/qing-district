FieldProxyGroup = require "../src/field-proxy-group.coffee"
assert - chai.assert

describe "FieldProxyGroup", ->

  $el = null
  group = null

  before ->
    $el = $("<div></div>").append 'body'

  beforeEach ->
    group = new FieldProxyGroup
      wrapper: $el

  it "should append el", ->
    assert.equal 1, $el.find(group.el).length

  it "setEmpty", ->
    group.setEmpty true
    assert group.el.is(".empty")
    group.setEmpty false
    assert.isNotOk group.el.is(".empty")
