#= require diffstring

describe "The diffstring method", ->
  # it "returns inserted and deleted text", ->
  #   text1 = "<p>Hi there you person!</p>"
  #   text2 = "<p>Hey there you!</p>"
  #   diff = diffString(text1, text2).replace(/\n/g, '')
  #   type = typeof diff
  #   expect(diff).toBe "<p><del>Hi</del><ins>Hey</ins> there <del>you</del><del>person!</del><ins>you!</ins></p>"
  #   expect(type).toBe 'string'

  it "returns the same text if not changes were found", ->
    text1 = "Hi there you person!"
    text2 = "Hi there you person!"
    diff = diffString(text1, text2).trim().replace(/\n/g, '').replace(/\s\s/g, ' ')
    type = typeof diff
    expect(diff).toBe text1

  describe "the is_html method", ->
    it "returns true if it is passed HTML", ->
      expect(is_html('<p>')).toBe(true)
      expect(is_html('</p>')).toBe(true)

    it "returns false if it is passed a non-HTML string", ->
      expect(is_html('foo')).toBe(false)
      expect(is_html('bar')).toBe(false)
