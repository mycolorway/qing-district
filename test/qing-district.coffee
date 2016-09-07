QingDistrict = require '../src/qing-district'
expect = chai.expect

describe 'QingDistrict', ->

  $el = null
  qingDistrict = null

  before ->
    $el = $('<div class="test-el"></div>').appendTo 'body'

  after ->
    $el.remove()
    $el = null

  beforeEach ->
    qingDistrict = new QingDistrict
      el: '.test-el'

  afterEach ->
    qingDistrict.destroy()
    qingDistrict = null

  it 'should inherit from QingModule', ->
    expect(qingDistrict).to.be.instanceof QingModule
    expect(qingDistrict).to.be.instanceof QingDistrict

  it 'should throw error when element not found', ->
    spy = sinon.spy QingDistrict
    try
      new spy
        el: '.not-exists'
    catch e

    expect(spy.calledWithNew()).to.be.true
    expect(spy.threw()).to.be.true
