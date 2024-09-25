# This scene can be dropped to anything that needs data persistence, and name in the scene tree can change
class_name PersistentDataHandler extends Node

signal data_loaded

var value : bool = false
#var coords : Vector2  ######################################## Folkor's method.  13 th


func _ready() -> void:
	#print(_get_name()) # Just to show myself what items are made to be data persistent in a scene
	get_data()
	pass


# For saving this persistent data. Called in TreasureChest script player_interact() eg.
func set_data() -> void:
	SaveManager.add_persistent_value( _get_name() )
	pass


# Called in _ready() above, so auto runs when the item with this script attached initializes
func get_data() -> void:
	value = SaveManager.check_persistent_value( _get_name() ) #value =true if this persistent data has been saved
	data_loaded.emit() # being connected to specific items made to be data persistent eg. TreasureChest script
	pass


func _get_name() -> String:
	# Return the String - res://levels/area01/01.tscn / treasurechest / PersistentDataHandler
	return get_tree().current_scene.scene_file_path + "/" + get_parent().name + "/" + name


## Folkor's method for location persistence------------------------------------------------------------
# Called in pushable_statue script (when statue stops)
func set_coords( global_pos : Vector2 ) -> void: 
	SaveManager.add_persistent_location( _get_name(), global_pos )
	print( SaveManager.current_save )
	pass
##----------------------------------------------------------------------------------------------------
