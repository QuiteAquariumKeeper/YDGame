## use a collisionShape2D to only monitor player's layer to see if enters transition area

@tool # allow to run the script in the editor
class_name LevelTransition extends Area2D

enum SIDE { LEFT, RIGHT, TOP, BOTTOM } # enum name is SIDE

@export_file( "*.tscn" ) var level # limit to scene files that we can choose from in Inspector
@export var target_tansition_area : String = "LevelTransition" # default name, change in Inspector

@export_category("Collision Area Settings")

# size 1-12 (default range), incremental 1, manually default to 2, but useer can put greater than 12.
# Turned on Local to Scene for the CollisionShape2D in Inspector under Resource so they are independent
@export_range( 1, 12, 1, "or_greater" ) var size = 2:
	set( _v ):
		size = _v
		_update_area() # this is running in the editor everytime the var is set

@export var side : SIDE = SIDE.LEFT:
	set( _v ):
		side = _v
		_update_area()

@export var snap_to_grid : bool = false:
	set( _v ):
		_snap_to_grid()

@onready var collision_shape = $CollisionShape2D # when change collision area settings will need to ref this



func _ready():
	_update_area()
	# if in the editor, don't need to do anthing else (don't run code used in the game):
	if Engine.is_editor_hint():
		return
	
	#monitoring = false # turn off while initializing in case player spawn on level transition area & glitch
	
	#Level transition only monitor player layer so don't need to specify whose body_entered (should only be player's
	body_entered.connect( _player_entered )
	
	pass


func _player_entered( _p : Node2D ) -> void: # _p represents player
	LevelManager.load_new_level( level, target_tansition_area, Vector2.ZERO ) # Note now may have 2 levels,
	# so need to remove the current level in Level script
	pass


## for setting collision shape (where levelTransition happens) size & pos:
func _update_area() -> void:
	var new_rec : Vector2 = Vector2( 32, 32 ) # default to 32 but can also be an export var
	var new_position : Vector2 = Vector2.ZERO
	
	if side == SIDE.TOP:
		new_rec.x *= size # if size = 2, new_rec = (64,32)
		new_position.y -= 16
	elif side == SIDE.BOTTOM:
		new_rec.x *= size
		new_position.y += 16
	elif side == SIDE.LEFT:
		new_rec.y *= size
		new_position.x -= 16
	elif side == SIDE.RIGHT:
		new_rec.y *= size
		new_position.x += 16
	
	# check if there's a collision shape (sometimes when rendering there might not be one)
	if collision_shape == null:
		collision_shape = get_node("CollisionShape2D") # if no, grab one
		
	collision_shape.shape.size = new_rec
	collision_shape.position = new_position


## for snap to grid (16 pixel - half tile). Not Necessary:
func _snap_to_grid() -> void:
	position.x = round( position.x / 16 ) * 16
	position.y = round( position.y / 16 ) * 16
