class_name EnemyStateWander extends EnemyState


@export var anim_name : String = "Walk" # animation name can be changed in Inspector with the rest of code working
@export var wander_speed : float = 20.0

@export_category("AI") # for categorying below
# don't want slime to change state while mid in the air (its walk is hopping)
@export var state_animation_duration : float = 0.5 # time takes for slime to complete walk anim (0.7s see animationplayer) 

@export var state_cycles_min : int = 1
@export var state_cycles_max : int = 3
@export var next_state : EnemyState

var _timer : float = 0.0
var _direction : Vector2

## what happens when we initialize this state?
func init() -> void :
	pass


## what happens when the player enters this State?
func enter() -> void:
	_timer = randi_range( state_cycles_min, state_cycles_max ) * state_animation_duration
	var rand = randi_range( 0, 3)
	_direction = enemy.DIR_4[ rand ]
	enemy.velocity = _direction * wander_speed
	enemy.set_direction( _direction )
	enemy.update_animation( anim_name )
	pass
	

## what happens when the player exits this State?
func exit() -> void:
	pass
	
	
## what happens during the _process update in this State?
func process( _delta : float) -> EnemyState: 
	_timer -= _delta
	if _timer < 0:
		return next_state
	return null # return null if no next_state
	
	
## what happens during the _physics_process update in this State?
func physics( _delta : float ) -> EnemyState:
	return null


