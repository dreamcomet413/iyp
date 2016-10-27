class Widget.Views.Offer extends Backbone.View

  render: ->
    if @model.get('display_type') == 1
      new Widget.Views.IframeOffer(el: $('body'), model: @model).render()
    else if @model.get('display_type') == 2
      new Widget.Views.StandardOffer(el: $('body'), model: @model).render()
    else if @model.get('display_type') == 3
      new Widget.Views.EmbeddedOffer(el: $('body'), model: @model).render()
    else if @model.get('display_type') == 4
      new Widget.Views.ImageOffer(el: $('body'), model: @model).render()
    @

