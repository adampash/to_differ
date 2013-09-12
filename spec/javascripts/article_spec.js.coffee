describe "Article", ->

  article = {}
  beforeEach ->
    json = getJSONFixture('article')
    article = new App.Article(json)

  it "can be instantianted", ->
    expect(typeof article).toBe 'object'

  it "can have several versions", ->
    expect(article.get('versions').length).toBeGreaterThan 1

  it "has a first selected version", ->
    version_text = article.get('first_version')
    version_number = article.get('first_selected_version')
    expect(version_number).toBe 1
    expect(version_text).toBe 'Hey friends and readers! I’m interrupting your daily dose of productivity and technology for a quick announcement'

  it "initializes with the last version selected", ->
    version_text = article.get('last_version')
    version_number = article.get('last_selected_version')
    expect(version_number).toBe 3
    expect(version_text).toBe "Hey friends and dearest of readers! I’m interrupting your daily dose of technology for a quick announcement"

  it "changes the version text when the version number changes", ->
    article.set('first_selected_version', 2)
    version_text = article.get('first_version')
    expect(version_text).toBe 'Hey friends of readers! I’m interrupting your daily dose of technology for a quick announcement'