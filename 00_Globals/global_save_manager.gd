## SaveManager auto load
extends Node

const SAVE_PATH = "user://"

signal game_loaded
signal game_saved


var current_save : Dictionary = {
	scene_path = "",
	player = {
		hp = 1,
		max_hp = 1,
		pos_x = 0,
		pos_y = 0
	},
	items = [], # Inventory items
	persistence = [],
	locations = [], # folkor's location persistence
	quests = [],
	saved_drops = [] # folkor's drops persistence
}
######################## Folkor Edit Start ###############################
func update_drop_data() -> void:
	var drops = get_drop_save_data()
	current_save.saved_drops = drops

func get_drop_save_data () -> Array:
# Gather the drops into an array
	var drop_save : Array = []
	for i in LevelManager.drops.size():
		drop_save.append( item_to_save( LevelManager.drops[i]["item_data"],LevelManager.drops[i]["pos_x"],LevelManager.drops[i]["pos_y"],LevelManager.drops[i]["scene"]) )
	return drop_save

func item_to_save ( drop : ItemData, pos_x, pos_y, _scene ) -> Dictionary:
# Convert the items into a dictionary
	var result = { item = '', posx = pos_x, posy = pos_y, scene = _scene }
	if drop != null:
		result.item = drop.resource_path
	return result
######################## Folkor Edit End ###############################
# getting called in pause_menu when press "save"
func save_game() -> void:
	update_player_data() # update player's data everytime before saving
	update_scene_path()
	update_item_data()
	update_drop_data() # Convert Drops into Strings for Storing. - Folkor
	var file := FileAccess.open( SAVE_PATH + "save.sav",FileAccess.WRITE ) #if no existing to open, 
	# will create one. Stringify will convert to string. Current_save is being saved which contains 
	# data persistence, so don't need to additionally call data persistence to save
	var save_json = JSON.stringify( current_save )
	file.store_line( save_json )
	game_saved.emit()
	pass
	

# getting called in pause_menu when press "load"
func load_game() -> void:
	var file := FileAccess.open( SAVE_PATH + "save.sav",FileAccess.READ )
	var json := JSON.new()
	json.parse( file.get_line() ) # getting the first line (Json has only 1 line) to json
	var save_dict : Dictionary = json.get_data() as Dictionary
	current_save = save_dict # update the current_save as per what in the file
	LevelManager.load_new_level( current_save.scene_path, "", Vector2.ZERO )
	
	await LevelManager.level_load_started # when screen is already black
	
	# everything to update the player happen here. use func in PlayerManager to Set player properties:
	PlayerManager.set_player_position( Vector2(current_save.player.pos_x, current_save.player.pos_y) )
	PlayerManager.set_health( current_save.player.hp, current_save.player.max_hp)
	print ("SAVED DROPS: "+str(current_save.saved_drops)+"\n")
	PlayerManager.INVENTORY_DATA.parse_save_data( current_save.items )
	
	await LevelManager.level_loaded
	game_loaded.emit()
	pass


func update_player_data() -> void:
	var p : Player = PlayerManager.player # for convenience, can use p to refer
	current_save.player.hp = p.hp
	current_save.player.max_hp = p.max_hp
	current_save.player.pos_x = p.global_position.x
	current_save.player.pos_y = p.global_position.y


func update_scene_path() -> void: # get path to which scene player's at before saving
	var p : String = ""
	for c in get_tree().root.get_children():
		if c is Level:
			p = c.scene_file_path
	current_save.scene_path = p

# Inventory---------------------------------------------------------------------------------------------
func update_item_data() -> void:
	current_save.items = PlayerManager.INVENTORY_DATA.get_save_data()
	
#-------------------------------------------------------------------------------------------------------
# Being called in PersistentDataHandler script
func add_persistent_value( value : String ) -> void:
	if check_persistent_value( value ) == false:
		current_save.persistence.append( value ) # If persistence array doesn't already have it, add it
	pass

# Being called in PersistentDataHandler script
func check_persistent_value( value : String ) -> bool:
	var p = current_save.persistence as Array
	return p.has( value ) # return true if p array has "value" ie. "value" has been saved


## Folkor's method for location persistence-----------------------------------------------------------
func add_persistent_location( value : String, coords : Vector2 ) -> void:
	if check_persistent_location( value ) == false:
		current_save.locations.append( {"name" = value, "pos_x" = coords.x, "pos_y" = coords.y} )
	else:
		remove_persistent_location( value )
		current_save.locations.append( {"name" = value, "pos_x" = coords.x, "pos_y" = coords.y} )
	pass

func check_persistent_location( value : String ) -> bool:
	for i in current_save.locations:
		if i["name"] == value:
			#print( "match")
			return true
	return false

func get_persistent_location( value : String ) -> Vector2:
	for i in current_save.locations:
		if i["name"] == value:
			#print( i["pos_x"], i["pos_y"] )
			return Vector2( i["pos_x"], i["pos_y"] )
	return Vector2.ZERO

func remove_persistent_location( value : String ) -> void:
	for i in current_save.locations:
		if i["name"] == value:
			current_save.locations.erase( i )

