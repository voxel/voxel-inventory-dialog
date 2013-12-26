# voxel-inventory-dialog

An inventory editing dialog for voxel.js:

![screenshot](http://i.imgur.com/WesAOTc.png "Screenshot")

The lower grid is an [inventory-window](https://github.com/deathcap/inventory-window)
of the the player's [inventory](https://github.com/deathcap/inventory), for storing items
(works well with [voxel-inventory-hotbar](https://github.com/deathcap/voxel-inventory-hotbar)
connected to a subset of the same inventory). 

The upper area is a 2x2 crafting grid to use a subset of available
[craftingrecipes](https://github.com/deathcap/craftingrecipes)
([voxel-workbench](https://github.com/deathcap/voxel-workbench) allows crafting with larger recipes),
the result picked up from the (pickup-only) rightmost slot. 

Uses [voxel-modal](https://github.com/deathcap/voxel-modal), so keyboard/mouse input
to the game will be suppressed when this dialog is visible. Click outside of the dialog
or hit Escape to close.

## License

MIT

