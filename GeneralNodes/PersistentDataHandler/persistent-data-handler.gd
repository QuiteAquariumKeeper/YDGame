# This scene can be dropped to anything that needs data persistence, and name in the scene tree can change
class_name PersistentDataHandler extends Node

signal data_loaded

var value : bool = false
var scene : String ## Folkor's drop persistence


func _ready() -> void:
	#print(_get_name()) # Just to show myself what items are made to be data persistent in a scene
	get_data()
	scene = get_tree().current_scene.scene_file_path ## Folkor's drops persistence
	pass


# For saving this persistent data. Called in TreasureChest script player_interact() eg.
func set_data() -> void:
	SaveManager.add_persistent_value( _get_name() )
	pass


# Called in _ready() above, so auto runs when the item with this script attached initializes
func get_data() -> void:
	value = SaveManager.check_persistent_value( _get_name() ) #value =true if this data has been saved
	data_loaded.emit() # connected to specific items made to be data persistent eg. TreasureChest script
	pass


func _get_name() -> String:
	# Return the String - res://levels/area01/01.tscn / treasurechest / PersistentDataHandler
	return get_tree().current_scene.scene_file_path + "/" + get_parent().name + "/" + name


## Folkor's method for location persistence------------------------------------------------------------
# Called in pushable_statue script (when statue stops)
func set_coords( global_pos : Vector2 ) -> void: 
	SaveManager.add_persistent_location( _get_name(), global_pos )
	#print( SaveManager.current_save )
	pass
##----------------------------------------------------------------------------------------------------

## Folkor's method for drop persistence-------------------------------------------------------------
#func clear_drop_value() -> void:
	#SaveManager.remove_persistent_drop( _get_name() )
	#pass

#func set_drop_value( global_pos : Vector2, item_data : ItemData ) -> void:
	#SaveManager.add_persistent_drop( _get_name(), get_parent().pre_exist, scene, global_pos, item_data )
	#print( SaveManager.current_save )
	#pass
