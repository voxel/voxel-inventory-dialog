# vim: set shiftwidth=2 tabstop=2 softtabstop=2 expandtab:

Inventory = require 'inventory'
InventoryWindow = require 'inventory-window'
ItemPile = require 'itempile'
{Recipe, AmorphousRecipe, PositionalRecipe, CraftingThesaurus, RecipeLocator} = require 'craftingrecipes'
Modal = require 'voxel-modal'

module.exports = (game, opts) ->
  new InventoryDialog(game, opts)

class InventoryDialog extends Modal
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

    super game, {
      element: @dialog, 
      escapeKeys:[27, 69] # escape, 'E'
      }

  enable: () ->

  disable: () ->

  # changed crafting grid, so update recipe output
  updateCraftingRecipe: () ->
    recipe = RecipeLocator.find(@craftInventory)
    console.log 'found recipe',recipe
    @resultInventory.set 0, recipe?.computeOutput(@craftInventory)

  # picked up crafting recipe output, so consume crafting grid ingredients
  tookCraftingOutput: () ->
    recipe = RecipeLocator.find(@craftInventory)
    return if not recipe?

    recipe.craft(@craftInventory)
    @craftInventory.changed()

