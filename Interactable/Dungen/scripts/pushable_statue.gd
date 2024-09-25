class_name PushableStatue extends RigidBody2D

@export var push_speed : float = 30.0

var push_direction : Vector2 = Vector2.ZERO : set = _set_push # Gets set in PushArea script in player

@onready var audio : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var persistent_location_has_moved = $PersistentLocation_HasMoved ## Folkor's method


## Folkor's method for location persistence------------------------------------------------------------
func _ready() -> void:
	LevelManager.level_load_started.connect( _set_statue_location ) # Folkor's SaveManager.game_loaded.connect
	_set_statue_location()
	pass


func _set_statue_location() -> void:
	var new_pos : Vector2
	if SaveManager.check_persistent_location( persistent_location_has_moved._get_name() ):
		print("exist")
		new_pos = SaveManager.get_persistent_location( persistent_location_has_moved._get_name() )
		global_position = new_pos
	print( str( new_pos ) )
	pass
## ---------------------------------------------------------------------------------------------------

func _physics_process( _delta : float ) -> void:
	linear_velocity = push_direction * push_speed # Linear_vel is property of physics_process
	pass
	

func _set_push( value : Vector2 ) -> void: # Called when push_dir gets Set above
	push_direction = value
	
	if push_direction == Vector2.ZERO:
		audio.stop()
		persistent_location_has_moved.set_coords( global_position ) ## Folker's method
	else:
		audio.play()
	pass
