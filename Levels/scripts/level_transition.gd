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



func _ready() -> void:
	_update_area()
	# if in the editor, don't need to do anthing else (don't run code used in the game):
	if Engine.is_editor_hint():
		return
	
	# turn off while initializing in case players pos overlap with a transition area on the new level & trigger imedieately
	monitoring = false
	# move player to the location he needs to be upon entering the new level just loaded; once moved, won't trigger another.
	_place_player()
	
	await LevelManager.level_loaded # the 1st level loaded signal is sent by Levelmanager _ready(), not func load_new_level(),
	# just to stop await & continue running
	
	monitoring = true # can turn on once we know the new level is completely loaded
	# Level transition only monitor player layer so don't need to specify whose body_entered (should only be player's
	body_entered.connect( _player_entered )
	pass


func _player_entered( _p : Node2D ) -> void: # _p represents player
	LevelManager.load_new_level( level, target_tansition_area, get_offset() ) # Note now may have 2 levels,
	# so need to remove the current level in Level script
	pass


# place player to the correct pos once transitioned to the next level:
func _place_player() -> void:
	# check if it's the correct transition area player should spawn next to. Name is of the new level (current one is removed)
	if name != LevelManager.target_transition:
		return
	#set player's global pos = global pos of the transition area + offset (get_offset() value already stored in position_offset
	PlayerManager.set_player_position( global_position + LevelManager.position_offset )


# get offset (player's global pos to the global pos point of the transition area
func get_offset() -> Vector2:
	var offset : Vector2 = Vector2.ZERO
	var player_pos = PlayerManager.player.global_position
	
	if side == SIDE.LEFT or side == SIDE.RIGHT:
		offset.y = player_pos.y - global_position.y # difference to the transition area pos point on y
		offset.x = 16 # on the edge of the transition area (16 to area pos point) (for right side)
		if side == SIDE.LEFT:
			offset.x *= -1
	else: # on top or bottom side
		offset.x = player_pos.x - global_position.x # difference to the transition area pos point on y
		offset.y = 16 # on the edge of the transition area (16 to area pos point)
		if side == SIDE.TOP:
			offset.y *= -1
			
	return offset


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
