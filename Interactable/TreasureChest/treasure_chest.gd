@tool
class_name TreasureChest extends Node2D

@export var item_data : ItemData: set = _set_item_data # gets set in Inspector before game
@export var quantity : int: set = _set_quantity # gets set in Inspector before game

var is_open : bool = false

@onready var item_sprite = $ItemSprite
@onready var label = $ItemSprite/Label
@onready var animation_player = $AnimationPlayer
@onready var interact_area = $Area2D


func _ready() -> void:
	_update_texture() # real-time update in editor
	_update_quantity() # real-time update in editor
	
	if Engine.is_editor_hint():
		return
	
	interact_area.area_entered.connect( _on_area_enter )
	interact_area.area_exited.connect( _on_area_exit )
	pass


func player_interact() -> void:
	if is_open == true:
		return
	is_open = true
	animation_player.play("open_chest")
	if item_data and quantity > 0: # check if there's item and quantity > 0 in chest
		PlayerManager.INVENTORY_DATA.add_item( item_data, quantity )
	else:
		printerr( "No Items in the Chest!" )
		push_error("No Items in the Chest! Chest Name: ", name ) # name is of the node (chest 01 e.g)
	pass
	
# When player's interact_area enters, check if need to open chest
func _on_area_enter( _a : Area2D) -> void:
	PlayerManager.interact_pressed.connect( player_interact )
	pass


# As soon as player leaves the area, stop checking if open chest
func _on_area_exit( _a : Area2D) -> void:
	PlayerManager.interact_pressed.disconnect( player_interact )
	pass


# Called when above @export var is set
func _set_item_data( value : ItemData ) -> void:
	item_data = value
	_update_texture() # if don't call, texture won't be updated in editor
	pass


# Called when above @export var is set
func _set_quantity( value : int) -> void:
	quantity = value
	_update_quantity() # if don't call, label(quantity) won't be updated in editor
	pass


func _update_texture() -> void:
	if item_data and item_sprite: # check both to avoid errors
		item_sprite.texture = item_data.texture
	pass


func _update_quantity() -> void:
	if item_data and label:
		if quantity <= 1:
			label.text = ""
		else:
			label.text = "x" + str( quantity )
