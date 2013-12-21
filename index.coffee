# vim: set shiftwidth=2 tabstop=2 softtabstop=2 expandtab:

Inventory = require 'inventory'
InventoryWindow = require 'inventory-window'

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
    @craftIW = new InventoryWindow {width:2, inventory:@craftInventory, getTexture:@getTexture}

    @dialog = document.createElement('div')
    @dialog.style.border = '6px grooved black'
    @dialog.style.visibility = 'hidden'
    @dialog.style.position = 'absolute'
    @dialog.style.top = '20%'
    @dialog.style.left = '30%'
    @dialog.style.zIndex = 1
    document.body.appendChild(@dialog)
   
    container = @craftIW.createContainer()
    container.style.float = 'right'
    @dialog.appendChild(container)
    @dialog.appendChild(document.createElement('br')) # TODO: better positioning
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

