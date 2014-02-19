
Inventory = require 'inventory'
InventoryWindow = require 'inventory-window'
ItemPile = require 'itempile'
ModalDialog = require 'voxel-modal-dialog'

module.exports = (game, opts) ->
  new InventoryDialog(game, opts)

module.exports.pluginInfo =
  'loadAfter': ['voxel-recipes', 'voxel-carry', 'voxel-registry']

class InventoryDialog extends ModalDialog
  constructor: (@game, opts) ->
    return if not @game.isClient # TODO: server

    @playerInventory = game.plugins?.get('voxel-carry')?.inventory ? opts.playerInventory ? throw new Error('voxel-inventory-dialog requires "voxel-carry" plugin or playerInventory" set to inventory instance')
    @recipes = game.plugins?.get('voxel-recipes') ? throw new Error('voxel-inventory-dialog requires "voxel-recipes" plugin')
    @registry = game.plugins?.get('voxel-registry') ? throw new Error('voxel-inventory-dialog requires "voxel-registry" plugin')

    @playerIW = new InventoryWindow {inventory:@playerInventory, registry:@registry}

    # upper section for any other stuff
    @upper = document.createElement('div')
    @upper.style.float = 'right'
    @upper.style.marginBottom = '10px'
   
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


