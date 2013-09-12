describe "Versions", ->
  it "can be instantianted", ->
    json = getJSONFixture('versions')
    version = new App.Version(json)
    expect(typeof version).toBe 'object'

  it "can have several versions", ->
    json = getJSONFixture('versions')
    version = new App.Version(json)
    expect(version.get('versions').length).toBeGreaterThan 1