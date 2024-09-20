class_name PushableStatue extends RigidBody2D

@export var push_speed : float = 30.0

var push_direction : Vector2 = Vector2.ZERO : set = _set_push # Gets set in PushArea script in player

@onready var audio : AudioStreamPlayer2D = $AudioStreamPlayer2D


func _physics_process( _delta : float ) -> void:
	linear_velocity = push_direction * push_speed # Linear_vel is property of physics_process
	pass
	

func _set_push( value : Vector2 ) -> void: # Called when push_dir gets Set above
	push_direction = value
	
	if push_direction == Vector2.ZERO:
		audio.stop()
	else:
		audio.play()
	pass
