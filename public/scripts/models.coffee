# Javascript has no classes, but there are some implementations
# in frameworks. Luckily, those of Coffeescript and Backbone
# are compatible, so we use backbone's class system.
#
# We're using a RelationalModel, defined in backbone-relational.js
# It's like a regular backbone model, but has relations. 
class window.Claim extends Backbone.RelationalModel
  relations: [
    type: Backbone.HasMany
    key: 'lines'
    relatedModel: 'Line'
    collectionType: 'LinesCollection'
    reverseRelation: 
      key: 'claim'
      includeInJSON: false
  ]

  # The url property is used by backbone for persistence.  
  # It can be a simple string property, but here we use a 
  # function. This way we can have different urls for existing
  # and new claims.
  #
  # Remember that @isNew() is shorthand for this.isNew()
  # Also note the string interpolation.
  
  url: -> if @isNew() then "/claims" else "/claims/#{@id}"

  # This is a typical custom business-logic method.
  countLines: ->
    @get('lines').length  
  
  
# Backbone has special collections, that are aware of the 
# Model type they contain
class window.ClaimsCollection extends Backbone.Collection
  model: window.Claim
  
  url: '/claims'
  
  # The initialize method gets called automatically
  # when you instantiate a backbone class.
  initialize: ->
    @bind "destroy", @modelRemoved
    
  modelRemoved: (model) ->
    @remove model
     

class window.Line extends Backbone.RelationalModel
  
    
class window.LinesCollection extends Backbone.Collection
  model: Line