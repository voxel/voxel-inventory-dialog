
Inventory = require 'inventory'
InventoryWindow = require 'inventory-window'
ItemPile = require 'itempile'
ModalDialog = require 'voxel-modal-dialog'

module.exports =
class InventoryDialog extends ModalDialog
  constructor: (@game, opts) ->
    return if not @game.isClient # TODO: server

    @playerInventory = game.plugins?.get('voxel-carry')?.inventory ? opts.playerInventory ? throw new Error('voxel-inventory-dialog requires "voxel-carry" plugin or playerInventory" set to inventory instance')

    @playerIW = new InventoryWindow {inventory:@playerInventory, registry:@registry}

    # upper section for any other stuff
    @upper = document.createElement('div')
    @upper.style.float = 'right'
    @upper.style.marginBottom = '10px'

    for element in (opts.upper ? [])
      @upper.appendChild element
   
    contents = []
    contents.push @upper
    contents.push document.createElement('br') # TODO: better positioning
    # player inventory at bottom
    contents.push @playerIW.createContainer()

    super game, {
      contents: contents
      escapeKeys:[192, 69] # '`', 'E'
      }

  enable: () ->

  disable: () ->


