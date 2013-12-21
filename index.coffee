# vim: set shiftwidth=2 tabstop=2 softtabstop=2 expandtab:

Inventory = require 'inventory'
InventoryWindow = require 'inventory-window'
ItemPile = require 'itempile'

module.exports = (game, opts) ->
  new InventoryDialog(game, opts)

class InventoryDialog
  constructor: (@game, opts) ->
    @playerInventory = opts.playerInventory ? throw 'voxel-inventory-dialog requires "playerInventory" set to inventory instance'
    @registry = opts.registry ? throw 'voxel-inventory-dialog requires "registry" set to voxel-registry instance'
    @getTexture = opts.getTexture ? (itemPile) => @game.materials.texturePath + @registry.getItemProps(itemPile.item).itemTexture + '.png' # TODO: refactor?

    @playerIW = new InventoryWindow {
      width: 10
      inventory: @playerInventory
      getTexture: @getTexture
      }

    @craftInventory = new Inventory(4)
    @craftInventory.on 'changed', () => @updateCraftingRecipe()
    @craftIW = new InventoryWindow {width:2, inventory:@craftInventory, getTexture:@getTexture}

    @resultInventory = new Inventory(1)
    @resultIW = new InventoryWindow {inventory:@resultInventory, getTexture:@getTexture, allowDrop:false}
    @resultIW.on 'pickup', () => @tookCraftingOutput()

    # the overall dialog
    @dialog = document.createElement('div')
    @dialog.style.border = '6px outset gray'
    @dialog.style.visibility = 'hidden'
    @dialog.style.position = 'absolute'
    @dialog.style.top = '20%'
    @dialog.style.left = '30%'
    @dialog.style.zIndex = 1
    @dialog.style.backgroundImage = 'linear-gradient(rgba(255,255,255,0.5) 0%, rgba(255,255,255,0.5) 100%)'
    document.body.appendChild(@dialog)

    # crafting + result div, upper
    crDiv = document.createElement('div')
    crDiv.style.float = 'right'
    crDiv.style.marginBottom = '10px'
   
    craftCont = @craftIW.createContainer()

    resultCont = @resultIW.createContainer()
    resultCont.style.marginLeft = '30px'
    resultCont.style.marginTop = '15%'

    crDiv.appendChild(craftCont)
    crDiv.appendChild(resultCont)

    @dialog.appendChild(crDiv)
    @dialog.appendChild(document.createElement('br')) # TODO: better positioning
    # player inventory at bottom
    @dialog.appendChild(@playerIW.createContainer())


  enable: () ->

  disable: () ->


  show: () ->
    @dialog.style.visibility = ''

  hide: () ->
    @dialog.style.visibility = 'hidden'

  isVisible: () ->
    return @dialog.style.visibility == ''

  toggle: () ->
    if @isVisible()
      @hide()
    else
      @show()

  # changed crafting grid, so update recipe output
  updateCraftingRecipe: () ->
    # TODO: recipes
    if @craftInventory.get(0)?.item == 'logOak'
      @resultInventory.set 0, new ItemPile('plankOak', 2)
    else
      @resultInventory.set 0, undefined

  # picked up crafting recipe output, so consume crafting grid ingredients
  tookCraftingOutput: () ->
    # TODO: consume per recipe
    @craftInventory.takeAt 0, 1
    @craftInventory.changed()

