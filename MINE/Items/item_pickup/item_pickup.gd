# Generic ItemPickup that can be dropped & assigned to other item Resources that can be picked up
@tool
class_name ItemPickup extends Node2D

@export var item_data : ItemData : set = _set_item_data

@onready var area_2d : Area2D = $Area2D
@onready var sprite_2d : Sprite2D = $Sprite2D
@onready var audio_stream_player_2d : AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready() -> void:
	_update_texture() # didn't add texture to our sprite2D (not neccessary as this is a @tool script can use Inspector
	if Engine.is_editor_hint():
		return
	area_2d.body_entered.connect( _on_body_entered )


func _on_body_entered( b ) -> void:
	if b is Player: # use is to check same class! not == !!
		if item_data: # can be instances where don't have itemData. It's being set in @export above (run in editor)
			# go to PlayerManager's INVENTORY_DATA bc the generic inventory_data can be for anything (like chest)
			if PlayerManager.INVENTORY_DATA.add_item( item_data ): # add_item() is a bool, so if true (ie. added)
				_item_picked_up() # only pick up when item can be added to inventory
	pass


func _item_picked_up() -> void:
	area_2d.body_entered.disconnect( _on_body_entered ) # disconnect once picked up, avoid repeated pick up
	audio_stream_player_2d.play()
	visible = false # wait till audio finish playing before queue free
	await audio_stream_player_2d.finished
	queue_free()
	pass


# getting called in @export var above, run in editor
func _set_item_data( variable : ItemData ) -> void:
	item_data = variable
	_update_texture()
	pass


func _update_texture() -> void:
	if item_data and sprite_2d: # check if we have both to avoid bug
		# so when drop this ItemPickup in a scene and select a ItemData, the sprite will change too (bc run in editor)
		sprite_2d.texture = item_data.texture
	pass
