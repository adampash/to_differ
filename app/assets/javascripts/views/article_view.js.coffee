
@App = @App || {}

class App.ArticleView extends Backbone.View
  # el: 'div.tests' # attaches `this.el` to an existing element.
  tagName: 'div' # attaches `this.el` to an existing element.
  initialize: ->
    _.bindAll(@, 'render') # fixes loss of context for 'this' within methods
    _.bindAll(@, 'render_slider') # fixes loss of context for 'this' within methods
    @template = _.template($('#item-template').html())
    @.$tiny = $('#tiny_article')
    @slider_template = _.template($('#slider-template').html())
    @listenTo(@model, 'change', @render_article)
    @render() # not all views are self-rendering. This one is.

  render: ->
    # console.log 'render'
    @render_article()
    @render_slider()

  render_slider: ->
    console.log 'render slider'
    view = @
    @.$el.prepend @slider_template(@.model.toJSON())
    @.$el.find('#slider').slider()
      .on 'slide', (event) ->
        view.change_versions event.value
    @.$el.find('.slider').width('100%')
    @.$el.find('.slider').height('70')
    @

  render_article: ->
    # console.log "diffing versions: ", @model.get('diffed_version').numbers
    if @.$article
      @.$el.find('.article').remove()
      @.$tiny.empty()
    # console.log 'render article'
    @.$article = @template(@.model.toJSON())
    @.$el.append(@.$article.replace(/\$del\$/g, '<del>').replace(/\$\/del\$/g, '</del>').replace(/\$ins\$/g, '<ins>').replace(/\$\/ins\$/g, '</ins>'))
    @.$tiny.append(@.$article)

    merge_adjacent('del')
    merge_adjacent('ins')
    @

  change_versions: (values) ->
    # console.log values
    @.model.set(
      first_selected_version: values[0]
      last_selected_version: values[1]
    )
  events:
    'click'                 : "hello_world"
    '#slider slide'         : 'hello_world'

  hello_world: ->
    console.log "Hello world"