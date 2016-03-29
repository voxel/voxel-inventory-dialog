'use strict';

const Inventory = require('inventory');
const InventoryWindow = require('inventory-window');
const ItemPile = require('itempile');
const ModalDialog = require('voxel-modal-dialog');

// plugin for example purposes
module.exports = (game, opts) => {
  return new InventoryDialog(game, opts);
}

module.exports.pluginInfo = {
  'loadAfter': ['voxel-recipes', 'voxel-carry', 'voxel-registry']
};


// class for extension in other plugins

class InventoryDialog extends ModalDialog {
  constructor(game, opts) {
    super(game, InventoryDialog.createInventoryDialogContent(opts));
  }

  static createInventoryDialogContent(opts) {
    const registry = game.plugins.get('voxel-registry');
    if (!registry) throw new Error('voxel-inventory-dialog requires "voxel-registry" plugin')

    const playerInventory = game.plugins.get('voxel-carry').inventory || opts.playerInventory; // TODO: proper error if voxel-carry missing
    if (!playerInventory) throw new Error('voxel-inventory-dialog requires "voxel-carry" plugin or playerInventory" set to inventory instance');

    const playerIW = new InventoryWindow({inventory: playerInventory, registry: registry, linkedInventory: opts.playerLinkedInventory});

    // upper section for any other stuff
    const upper = document.createElement('div');

    if (opts.upper) {
      for (let element of opts.upper) {
        upper.appendChild(element);
      }
    }
   
    const contents = [];
    contents.push(upper);
    contents.push(document.createElement('br')); // TODO: better positioning
    // player inventory at bottom
    contents.push(playerIW.createContainer());

    opts.contents = contents;
    opts.escapeKeys = [192, 69]; // '`', 'E';

    return opts;
  }

  enable() {
  }

  disable() {
  }
}

module.exports.InventoryDialog = InventoryDialog


