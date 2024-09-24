# Generic ItemPickup that can be used to match other item Resources that can be picked up (eg. drops)
# ItemPickup scene changed type to charactorbody2D to give a speed as drops and collision to walls.
@tool
class_name ItemPickup extends CharacterBody2D

signal has_picked_up # For item_dropper script (dungen key only records persistence when picked up)

@export var item_data : ItemData : set = _set_item_data

var picked_up : bool = false # for data persistence

@onready var area_2d : Area2D = $Area2D
@onready var sprite_2d : Sprite2D = $Sprite2D
@onready var audio_stream_player_2d : AudioStreamPlayer2D = $AudioStreamPlayer2D
#@onready var animation_player = $AnimationPlayer # Don't work for some reason (E19 comments abt bounce)
@onready var persistent_data_pickedup : PersistentDataHandler = $"PersistentData-PickedUp"


func _ready() -> void:
	_update_texture() # didn't add texture to sprite2D (not neccessary as it's @tool script, can use Inspector
	if Engine.is_editor_hint():
		return
	area_2d.body_entered.connect( _on_body_entered )
	
	# For data persistence:
	#persistent_data_pickedup.data_loaded.connect( set_item_state )
	#set_item_state()
	
	#persistent_data_dropped.set_drop_value( global_position, item_data ) ######################################## Folkor's method.  13 th


# For data persistent
func set_item_state() -> void:
	picked_up = persistent_data_pickedup.value
	if picked_up: # picked_up is bool. ie. if it's true:
		queue_free()
	else:
		return


# For drop items to bounce off walls if near walls
func _physics_process( delta : float ) -> void:
	# move-and_collide returns a KinematicCollision2D, containing info of a collision when stopped
	var collision_info = move_and_collide( velocity * delta )
	if collision_info: # if there's a collision if ie. a collision happened
		# Get the colliding body's shape's (wall's) normal at the point of collision. Then bounce.
		velocity = velocity.bounce( collision_info.get_normal() )
	# for gradually decresing velocity (can use @export var to determine friction, but here is 4)
	velocity -= velocity * delta * 4


func _on_body_entered( b ) -> void:
	if b is Player: # use is to check same class! not == !!
		if item_data: # can be instances where don't have itemData. It's being set in @export above (run in editor)
			# go to PlayerManager's INVENTORY_DATA bc the generic inventory_data can be for anything (like chest)
			if PlayerManager.INVENTORY_DATA.add_item( item_data ): # add_item() is a bool, so if true (ie. added)
				_item_picked_up() # only pick up when item can be added to inventory
				
				#persistent_data_pickedup.set_data() # add data persistence once picked up # Mine. dungen key sometiems don't instantiate
	pass


func _item_picked_up() -> void:
	area_2d.body_entered.disconnect( _on_body_entered ) # disconnect once picked up, avoid repeated pick up
	audio_stream_player_2d.play()
	visible = false # wait till audio finish playing before queue free
	has_picked_up.emit() # Emits to item_dropper script for data persistence
	await audio_stream_player_2d.finished
	#persistent_data_dropped.clear_drop_valuue() ######################################## Folkor's method.  13 th
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


# ADDED MYSELF. for playing bounce anim when enemy drop, don't need bounce when instantiate in the scene
func bounce() -> void:
	$AnimationPlayer.play("bounce") # only local ref not @onready ref, as it doesn't work (see E19 comments)
	pass
