## For dropping items eg. a key in dungen. Label is for seeing in editor, not used in game
@tool
class_name ItemDropper extends Node2D

# Dropped item need to be sth that can be picked up, so will instantiate as an ItemPickup type
const PICKUP = preload("res://Items/item_pickup/item_pickup.tscn")

@export var item_data : ItemData: set = _set_item_data

var has_dropped : bool = false

@onready var sprite : Sprite2D = $Sprite2D
@onready var persistent_data_has_dropped : PersistentDataHandler = $PersistentData_HasDropped
@onready var audio : AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	if Engine.is_editor_hint() == true:
		_update_texture() # So when go to editor, can see the right texture updated
		return
	
	sprite.visible = false # The sprite is only for displaying in editor (text)
	persistent_data_has_dropped.data_loaded.connect( _set_drop_state ) # Michael's is _on_data_loaded
	_set_drop_state()
	pass


func drop_item() -> void: # Called when enemies_defeated signal fires by Node
	if has_dropped == true:
		return
	has_dropped = true
	
	var drop = PICKUP.instantiate() as ItemPickup
	drop.item_data = item_data
	get_parent().call_deferred( "add_child", drop ) ## Changed from add_child 26th
	drop.global_position = global_position ## Mine 26th
	drop.has_picked_up.connect( _on_drop_picked_up )
	audio.play()


func _on_drop_picked_up() -> void:
	persistent_data_has_dropped.set_data() # only persistent when the key has been picked up
	

func _set_drop_state() -> void: # For data persis. Michael's named it _on_data_loaded
	has_dropped = persistent_data_has_dropped.value
	

func _set_item_data( value : ItemData ) -> void: # Called in set above
	item_data = value
	_update_texture()
	

func _update_texture() -> void:
	if Engine.is_editor_hint() == true: # When the code is running in the editor:
		if item_data and sprite:
			sprite.texture = item_data.texture
