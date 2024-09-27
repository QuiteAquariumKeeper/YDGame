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

var drops = [] # Drop Tracking - Folkor

# for loading the first level so level_transition script _ready() can run
func _ready() -> void:
	 # wait for the first process frame ie. all scenes are loaded, level transition & first level is loaded
	await get_tree().process_frame
	level_loaded.emit() # to be picked up in level_transition _ready(), just to make it stop waiting & run rest of the code
	

func ChangeTilemapBounds( bounds : Array[ Vector2] ) -> void: # getting called in LevelTileMap
	# 2 ways for getting bounds from this global script - directly refing var or connect to signal
	current_tilemap_bounds = bounds
	TileMapBoundsChanged.emit( bounds )


# for loading levels for level transitions. Getting called in level_transition:
func load_new_level(
		level_path : String,
		_target_transition : String,
		_position_offset : Vector2
) -> void:
	
	get_tree().paused = true # pause game, avoid transition level taking too long and getting chased by emnemy
	target_transition = _target_transition
	position_offset = _position_offset
	
	# black screen anima, SceneTransition node set to 'always' for Process in Inspector so ignores pause
	await SceneTransition.fade_out()
	
	level_load_started.emit()
	
	await get_tree().process_frame # wait for the next process frame, make sure the current level is removed
	
	get_tree().change_scene_to_file( level_path ) # change to the new level
	
	await SceneTransition.fade_in()
	
	get_tree().paused = false # unpause game
	
	await get_tree().process_frame
	
	level_loaded.emit()
	
	pass


## ------------------------------------------------------------------------------------------------

## Folkor's method for drops persistence----------------------------------------------------------
func add_persistent_drop( value: String, pre_exist : String, scene: String, coords: Vector2, item: ItemData) -> void:
	if check_persistent_drop( value ) == false:
		drops.append( {
			"name" = value, 
			"pre_exist" = pre_exist,
			"scene" = scene,
			"pos_x" = coords.x,
			"pos_y" = coords.y,
			"item_data" = item
			} )
	else:
		remove_persistent_drop( value )
		drops.append( {
			"name" = value, 
			"pre_exist" = pre_exist,
			"scene" = scene,
			"pos_x" = coords.x,
			"pos_y" = coords.y,
			"item_data" = item
			} )
	pass

func check_persistent_drop( value : String ) -> bool:
	for i in drops:
		if i["name"] == value:
			print("Match")
			return true
	return false

func remove_persistent_drop( value : String ) -> void:
	for i in drops:
		if i["scene"] == value: ## Mine 26th
			drops.erase( i )
##------------------------------------------------------------------------------------------------
