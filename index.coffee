# vim: set shiftwidth=2 tabstop=2 softtabstop=2 expandtab:

InventoryWindow = require 'inventory-window'

module.exports = (game, opts) ->
  new InventoryDialog(game, opts)

class InventoryDialog
  constructor: (@game, opts) ->
    @playerInventory = opts.playerInventory ? throw 'voxel-inventory-dialog requires "playerInventory" set to inventory instance'
    @registry = opts.registry ? throw 'voxel-inventory-dialog requires "registry" set to voxel-registry instance'

    @playerIW = new InventoryWindow {
      width: 10
      inventory: @playerInventory
      getTexture: (itemPile) => @game.materials.texturePath + @registry.getItemProps(itemPile.item).itemTexture + '.png' # TODO: refactor?
      }

    container = @playerIW.createContainer()

    container.style.visibility = 'hidden'
    container.style.position = 'absolute'
    container.style.top = '20%'
    container.style.left = '30%'
    container.style.zIndex = 1
    document.body.appendChild(container)

  enable: () ->

  disable: () ->


  show: () ->
    @playerIW.container.style.visibility = ''

  hide: () ->
    @playerIW.container.style.visibility = 'hidden'

  isVisible: () ->
    return @playerIW.container.style.visibility == ''

  toggle: () ->
    if @isVisible()
      @hide()
    else
      @show()

