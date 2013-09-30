# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@App = @App || {}

class App.Article extends Backbone.Model
  defaults:
    first_selected_version: 1
  initialize: ->
    @bind('change', @computedAttributes, @)
    @set_last_version()
    @computedAttributes()

  set_last_version: ->
    @.set('last_selected_version', @.get('versions').length)

  computedAttributes: ->
    @.set(
      first_version   : @.get('versions')[@.get('first_selected_version') - 1].text
      last_version    : @.get('versions')[@.get('last_selected_version') - 1].text
      total_versions  : @.get('versions').length
    )
    @.set(
      diffed_version  :
        text: diffString(@.get('first_version'), @.get('last_version'))
        numbers:
          [
            @.get('first_selected_version')
            @.get('last_selected_version')
          ]
    )