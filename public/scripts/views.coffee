# The views are wrapped in a function that gets called at onready.
# Reason for this is that our templates are loaded asynchronously, and
# the template engine we use can't handle unloaded templates. So all 
# the views must be loaded after the templates.
#
# The line '$ ->' compiles to javascript '$(function() {});',
$ ->

  # A view extends the Backbone.View class
  class window.HomeView extends Backbone.View
    
    # If you specify a 'tagName' property, backbone will create
    # the element for you, and make it available in @el.
    tagName: "div"
    
    initialize: (content) ->
      $(@el).append content
  
  # A view for the list of claims
  class window.ClaimListView extends Backbone.View
    tagName: "div"
    
    # We use the 
    template: _.template $("#claimList-template").html()
 
    # The @model is passed in in an object as the first parameter to initialize.
    # Since that is so common, Backbone handles storing the parameter 'model' into
    # @model automatically for you.
    # 
    # Here we bind all events of the model to @render   
    initialize: ->
      @model.bind "all", @render
    
    # Not the double line arrow here. In the initialize method, we bound render
    # to events on the model. If we would use a single line arrow here, the 'this'
    # variable (or @) in this method would refer to the model, but we want it
    # to refer to this view. By using the double line arrow, Coffeescript wraps
    # it in a funky way to preserve the original 'this'.
    render: =>
      $(@el).empty()
      $(@el).append @template {}
      
      # We loop over each claim in this list of claims, and
      # instantiate a new view for each of the claims.
      # We then call render to have it rendered. Render returns 'this' (you should
      # always do that), so we can chain here. The 'el' field holds the html structure
      # that we then insert into the DOM with append. 
      _(@model.models).each (claim) =>
        view = new ClaimListElementView model: claim, claims: @model
        $('tbody', @el).append view.render().el
      
      # Always return 'this' at the end of a render method.
      return this  
  
  # A view for a single row in the list of claims
  class window.ClaimListElementView extends Backbone.View
    
    tagName: "tr"
    
    template: _.template $('#claimListElement-template').html()
    
    # We get two params: model and claims. 'model' is saved automatically
    # by backbone, so we just have to handle 'claims'
    initialize: (opts) ->
      @claims = opts.claims
    
    # In a View, you can bind events in an events hash. The key is the 
    # event you want to bind to and a selector, the value is the method
    # you want triggered. 
    #
    # The selectors are local in the element of this view. So in this case,
    # only the .delete and .update in the current row.
    events: 
      'click .delete' : "destroy"
      'click .update' : "update"
      
    destroy: =>
      @model.destroy()
  
    # After update, we invoke the router programmatically. 
    # Note the string interpolation
    update: => 
      window.app.navigate "#/claims/#{@model.id}", true
    
    # Render the row
    render: =>
      $(@el).empty()
      
      # Here we use toJSON, just because we can. You can also just give
      # the @model to the template.
      $(@el).append @template @model.toJSON()
      
      # We're returning this, but since Coffeescript automatically
      # returns the last expression, we left off the 'return' keyword this time
      this
  
  
  
  #
  #
  # Tutorial comments end here.
  #
  # 
  
  
  
  
  class window.ClaimCreateUpdateView extends Backbone.View
    tagName: 'div'
    
    template: _.template $('#claimCreateUpdateView-template').html()
    
    initialize: (opts) ->
      @claims = opts.claims
    
    events:
      "click #save": "save"
      "click #add": "addLine"
      "keyup #claimFields": "updateProperties"
      
    save: =>
      @updateProperties()
      
      wasNew = @model.isNew
      @model.save {},
        success: (model) =>
          if wasNew then @claims.add model
          window.app.navigate "#/claims", true 
        error: (a, b) ->
          alert "Error!"
    
    addLine: =>
      new Line("claim" : @model)
      @render()
      
    updateProperties: =>
      @model.set
        "claimDate"     : $('#claimDate').val()
        "startDate"     : $('#startDate').val()
        "endDate"       : $('#endDate').val()
        "accountNumber" : $('#accountNumber').val()
        "accountName"   : $('#accountName').val()
        
    render: =>
      $(@el).empty()
      $(@el).append @template claim: @model
      
      headingText = (if @model.isNew() then "Create" else "Update") + " claim"
      $('h1', @el).text headingText
      
      # Add some initial claim lines for a new and empty claim
      if @model.isNew() && @model.countLines() == 0
        # Add three empty lines
        new Line("claim" : @model) for [1..3] 
      
      # Render lines into the tbody 
      _(@model.get("lines").models).each (line) =>
        
        lineView = new window.LineView model: line
        $('tbody', @el).append lineView.render().el
        
      this
    
  class window.LineView extends Backbone.View
    tagName: "tr"
    
    template: _.template $("#claimLineCreateUpdate-template").html()
    
    "events":
      "keyup input": "updateProperties"
    
    updateProperties: =>
      @model.set
        date         : $('input[name=date]', @el).val()
        amountExVat  : parseFloat($('input[name=amountExVat]', @el).val())
        vat          : parseFloat($('input[name=vat]', @el).val())
        amountIncVat : parseFloat($('input[name=amountIncVat]', @el).val())
        description  : $('input[name=description]', @el).val() 
        
    render: =>
      $(@el).empty()
      $(@el).append(@template line: @model)
      this
      