# voxel-inventory-dialog

A player inventory editing dialog for voxel.js:

![screenshot](http://i.imgur.com/9scWlpR.png "Screenshot")

The lower grid is an [inventory-window](https://github.com/deathcap/inventory-window)
of the the player's [inventory](https://github.com/deathcap/inventory) from
[voxel-carry](https://github.com/deathcap/voxel-carry).

The upper area is customizable by passing in elements into the
`upper` option. While voxel-inventory-dialog can be loaded as a plugin on its own,
it is most useful when extended by other plugins using this option. Used by:

* [voxel-inventory-crafting](https://github.com/deathcap/voxel-inventory-crafting)
* [voxel-furnace](https://github.com/deathcap/voxel-furnace)
* [voxel-workbench](https://github.com/deathcap/voxel-workbench)
* [voxel-chest](https://github.com/deathcap/voxel-chest)

Uses [voxel-modal-dialog](https://github.com/deathcap/voxel-modal-dialog), so keyboard/mouse input
to the game will be suppressed when this dialog is visible. Click outside of the dialog
or hit Escape to close.

## License

MIT

