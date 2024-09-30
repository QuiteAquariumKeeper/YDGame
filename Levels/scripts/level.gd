## for making the spawned player (instantiated from global PlayerManager) a child of the level root node
## (Playground/01/02/03) so Y sort works
class_name Level extends Node2D

const PICKUP = preload("res://Items/item_pickup/item_pickup.tscn") ## Folkor's drops persistence
var scene : String ## Folkor's drops persistence


func _ready():
	self.y_sort_enabled = true # to be safe
	PlayerManager.set_as_parent( self ) # making level script (attached to 01/02/03) parent of player
	# remove current level when level_load_started during level transition
	LevelManager.level_load_started.connect( _free_level )
	
	scene = get_tree().current_scene.scene_file_path ## Folkor's drops persistence
	
	#SaveManager.start_saving.connect( store_drops ) ## Mine 27th
	tree_exited.connect( store_drops ) ## Mine 26th
	#PauseMenu.shown.connect( store_drops ) ## Mine 28th
	#SaveManager.game_loaded.connect( check_for_saved_drops )
	check_for_realtime_drops()
	


# for removing the current level during level transition
func _free_level() -> void:
	# remove child Player before removing the current level so we still have the player
	PlayerManager.unparent_player( self )
	queue_free() # remove level


## Folkor's drops persistence ------------------------------------------------------------------------
func check_for_realtime_drops() -> void:
	print ("Checking for RealTime drops")
	var drops = LevelManager.drops
	for i in range( drops.size(), 0, -1): # i is 10 to 1 if size = 10
		var d = drops[ i-1 ] # if i is 10, d = drops[9]
		if d["scene"] == scene:
			add_drop( d["item_data"], d["pos_x"], d["pos_y"] )
			LevelManager.drops.erase( d )
	check_for_saved_drops()
	pass

######################## Folkor Edit Start ###############################
func check_for_saved_drops() -> void:
	print ("Checking for SAVED drops")
	var saved_drops = SaveManager.current_save.saved_drops
	for i in range(saved_drops.size(), 0, -1):
		var d = SaveManager.current_save.saved_drops[i-1]
		if d["scene"] == scene:
			print ("Found SAVED item for this scene.")
			d["item_data"] = parse_save_data( d["item"] )
			add_drop(d["item_data"],d["posx"],d["posy"])
			#SaveManager.current_save.saved_drops.erase(d)
	pass

func parse_save_data ( res_name : String ) -> ItemData:
	print (res_name)
	var item = item_from_save( res_name )
	print (item)
	return item

func item_from_save ( save_object : String ) -> ItemData:
	var item = load( save_object )
	return item
######################## Folkor Edit End ###############################

func add_drop( item : ItemData, pos_x: float, pos_y : float ) -> void:
	var drop : ItemPickup = PICKUP.instantiate() as ItemPickup
	drop.item_data = item
	call_deferred( "add_child", drop )
	drop.global_position = Vector2( pos_x, pos_y )
	pass
##---------------------------------------------------------------------------------------------------
## My method 26th-----------------------------------------------------------------------------------
func store_drops() -> void:
	for c in get_children():
		if c is ItemPickup and c.pre_exist == "NO":
			LevelManager.add_persistent_drop( c.name_path, c.pre_exist, scene, c.global_position, c.item_data )
	print( LevelManager.drops )
