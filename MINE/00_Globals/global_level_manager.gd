## LevelManager Autoload script, don't need class name. For managing level type info. 
extends Node

# for level transitions
signal level_load_started
signal level_loaded
# for updating camera to not go beyound tile bounds
signal TileMapBoundsChanged( bounds : Array[ Vector2] )

# for level transitions
var target_transition : String
var position_offset : Vector2 # offset player's pos
# for updating camera to not go beyound tile bounds
var current_tilemap_bounds : Array[ Vector2 ] # 2 vectors of the top left and bottom right coor


func ChangeTilemapBounds( bounds : Array[ Vector2] ) -> void: # getting called in LevelTileMap
	# 2 ways for getting bounds from this global script - directly refing var or connect to signal
	current_tilemap_bounds = bounds
	TileMapBoundsChanged.emit( bounds )


## for loading levels for level transitions. Getting called in level_transition:
func load_new_level(
		level_path : String,
		_target_transition : String,
		_position_offset : Vector2
) -> void:
	
	get_tree().paused = true # pause game
	target_transition = _target_transition
	position_offset = _position_offset
	
	await get_tree().process_frame # Level Transition
	
	level_load_started.emit()
	
	await get_tree().process_frame # wait for the next process tick, make sure the current level is removed
	
	get_tree().change_scene_to_file( level_path ) # change to the new level
	
	await get_tree().process_frame # Level Transition
	
	get_tree().paused = false # unpause game
	
	await get_tree().process_frame
	
	level_loaded.emit()
	
	pass
