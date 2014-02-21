
Inventory = require 'inventory'
InventoryWindow = require 'inventory-window'
ItemPile = require 'itempile'
ModalDialog = require 'voxel-modal-dialog'

# plugin for example purposes
module.exports = (game, opts) ->
  new InventoryDialog(game, opts)

module.exports.pluginInfo =
  'loadAfter': ['voxel-recipes', 'voxel-carry', 'voxel-registry']


# class for extension in other plugins
module.exports.InventoryDialog =
class InventoryDialog extends ModalDialog
  constructor: (@game, opts) ->
    return if not @game.isClient # TODO: server

    @registry = game.plugins?.get('voxel-registry') ? throw new Error('voxel-inventory-dialog requires "voxel-registry" plugin')
    @playerInventory = game.plugins?.get('voxel-carry')?.inventory ? opts.playerInventory ? throw new Error('voxel-inventory-dialog requires "voxel-carry" plugin or playerInventory" set to inventory instance')

    @playerIW = new InventoryWindow {inventory:@playerInventory, registry:@registry, linkedInventory:opts.playerLinkedInventory}

    # upper section for any other stuff
    @upper = document.createElement('div')

    for element in (opts.upper ? [])
      @upper.appendChild element
   
    contents = []
    contents.push @upper
    contents.push document.createElement('br') # TODO: better positioning
    # player inventory at bottom
    contents.push @playerIW.createContainer()

    super game,
      contents: contents
      escapeKeys:[192, 69] # '`', 'E'

  enable: () ->

  disable: () ->


