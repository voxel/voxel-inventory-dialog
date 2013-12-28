# vim: set shiftwidth=2 tabstop=2 softtabstop=2 expandtab:

Inventory = require 'inventory'
InventoryWindow = require 'inventory-window'
ItemPile = require 'itempile'
ModalDialog = require 'voxel-modal-dialog'

module.exports = (game, opts) ->
  new InventoryDialog(game, opts)

module.exports.pluginInfo =
  'loadAfter': ['craftingrecipes', 'voxel-carry']

class InventoryDialog extends ModalDialog
  constructor: (@game, opts) ->
    @playerInventory = game.plugins?.get('voxel-carry')?.inventory ? opts.playerInventory ? throw 'voxel-inventory-dialog requires "voxel-carry" plugin or playerInventory" set to inventory instance'
    @recipes = game.plugins?.get('craftingrecipes') ? throw 'voxel-inventory-dialog requires "craftingrecipes" plugin'

    @playerIW = new InventoryWindow {
      inventory: @playerInventory
      }

    @craftInventory = new Inventory(2, 2)
    @craftInventory.on 'changed', () => @updateCraftingRecipe()
    @craftIW = new InventoryWindow {inventory:@craftInventory}

    @resultInventory = new Inventory(1)
    @resultIW = new InventoryWindow {inventory:@resultInventory, allowDrop:false, linkedInventory:@playerInventory}
    @resultIW.on 'pickup', () => @tookCraftingOutput()

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

    contents = []
    contents.push crDiv
    contents.push document.createElement('br') # TODO: better positioning
    # player inventory at bottom
    contents.push @playerIW.createContainer()

    super game, {
      contents: contents
      escapeKeys:[27, 69] # escape, 'E'
      }

  enable: () ->

  disable: () ->

  # changed crafting grid, so update recipe output
  updateCraftingRecipe: () ->
    recipe = @recipes.find(@craftInventory)
    console.log 'found recipe',recipe
    @resultInventory.set 0, recipe?.computeOutput(@craftInventory)

  # picked up crafting recipe output, so consume crafting grid ingredients
  tookCraftingOutput: () ->
    recipe = @recipes.find(@craftInventory)
    return if not recipe?

    recipe.craft(@craftInventory)
    @craftInventory.changed()

