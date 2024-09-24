class_name LockedDoor extends Node2D

var is_open : bool = false

@export var key_item : ItemData # What type of item can open me?
@export var locked_audio : AudioStream
@export var open_audio : AudioStream

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var audio : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var persistent_data_is_open : PersistentDataHandler = $PersistentData_IsOpen
@onready var interact_area : Area2D = $InteractArea2D


func _ready() -> void:
	 # Monitoring area (player's interact area) not body enter/exit. Same as chest
	interact_area.area_entered.connect( _on_area_entered )
	interact_area.area_exited.connect( _on_area_exited )
	
	# For data persistence
	persistent_data_is_open.data_loaded.connect( set_door_state )
	set_door_state()
	pass


func open_door() -> void:
	if key_item == null: # Check if have key
		return
	
	var door_unlocked : bool = PlayerManager.INVENTORY_DATA.use_item( key_item ) # True if can use
	
	if door_unlocked: # it's true
		animation_player.play( "open_door" )
		audio.stream = open_audio
		persistent_data_is_open.set_data()
	else:
		audio.stream = locked_audio
	
	audio.play()
	pass


func close_door() -> void: # Not being used atm
	animation_player.play( "close_door" )
	pass


func set_door_state() -> void:
	is_open = persistent_data_is_open.value
	if is_open:
		animation_player.play( "opened" )
	else:
		animation_player.play( "closed" )
	pass


func _on_area_entered( _a : Area2D ) -> void:
	PlayerManager.interact_pressed.connect( open_door )
	pass


func _on_area_exited( _a : Area2D ) -> void:
	PlayerManager.interact_pressed.disconnect( open_door )
	pass
