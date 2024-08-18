## Autoload script, don't need class name, added in Project Setting with name LevelManager. 
## For managing level type info. 
extends Node


var current_tilemap_bounds : Array[ Vector2 ] # 2 vectors of the top left and bottom right coor
signal TileMapBoundsChanged( bounds : Array[ Vector2] )

func ChangeTilemapBounds( bounds : Array[ Vector2] ) -> void: # getting called in LevelTileMap
	# 2 ways for getting bounds from this global script - directly refing var or connect to signal
	current_tilemap_bounds = bounds
	TileMapBoundsChanged.emit( bounds )
