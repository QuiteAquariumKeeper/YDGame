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
	
	tree_exited.connect( store_drops ) ## Mine 26th
	check_for_previous_drops() ## Folkor's drops persistence


# for removing the current level during level transition
func _free_level() -> void:
	# remove child Player before removing the current level so we still have the player
	PlayerManager.unparent_player( self )
	queue_free() # remove level


## Folkor's drops persistence ------------------------------------------------------------------------
func check_for_previous_drops() -> void:
	var drops = SaveManager.current_save.drops
	for i in range( drops.size(), 0, -1): # i is 10 to 1 if size = 10
		var d = drops[ i-1 ] # if i is 10, d = drops[9]
		if d["scene"] == scene:
			add_drop( d["item_data"], d["pos_x"], d["pos_y"] )
			SaveManager.current_save.drops.erase( d )
	pass

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
			SaveManager.add_persistent_drop( c.name_path, c.pre_exist, scene, c.global_position, c.item_data )
	print( SaveManager.current_save )
