DataStore = require "../src/data-store.coffee"
data = require './fixtures/data.js'
assert = chai.assert

describe "DataStore", ->

  it "trigger loaded", ->
    store = new DataStore
    loadedCallback = sinon.spy()
    store.on "loaded", loadedCallback
    store.load (callback) ->
      callback data
    assert loadedCallback.called
