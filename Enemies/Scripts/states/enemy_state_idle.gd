class_name EnemyStateIdle extends EnemyState


@export var anim_name : String = "Idle" # animation name can be changed in Inspector with the rest of code working

@export_category("AI") # for categorying below
@export var state_duration_min : float = 0.5
@export var state_duration_max : float = 1.5
@export var next_state : EnemyState

var _timer : float = 0.0

## what happens when we initialize this state?
func init() -> void :
	pass


## what happens when the player enters this State?
func enter() -> void:
	enemy.velocity = Vector2.ZERO
	_timer = randf_range( state_duration_min, state_duration_max ) # random float range
	enemy.update_animation( anim_name )
	pass
	

## what happens when the player exits this State?
func exit() -> void:
	pass
	
	
## what happens during the _process update in this State?
func process( _delta : float) -> EnemyState: 
	_timer -= _delta
	if _timer <= 0:
		return next_state
	return null # return null if no next_state
	
	
## what happens during the _physics_process update in this State?
func physics( _delta : float ) -> EnemyState:
	return null


