class_name EnemyStateStun extends EnemyState


@export var anim_name : String = "Stun" # anim name can change in Inspector with the rest of code working
@export var knockback_speed : float = 200.0
@export var decelerate_speed : float = 10.0

@export_category("AI") # for categorying below
@export var next_state : EnemyState

var _damage_position : Vector2 # Calculated in _on_enemy_damaged() below
var _direction : Vector2
var _animation_finished : bool = false

## what happens when we initialize this state?
func init() -> void : # each state will be initialised in the enemy_state_machine
	enemy.enemy_damaged.connect( _on_enemy_damaged )
	pass


## what happens when the player enters this State?
func enter() -> void:
	enemy.invulnerable = true
	_animation_finished = false
	
	# global_pos is the pos in the game world, position is its pos within his parent node. It's direction
	# to the hurtbox (of the player in this case)
	_direction = enemy.global_position.direction_to( _damage_position )
	
	enemy.set_direction( _direction )
	enemy.velocity = _direction * -knockback_speed
	
	enemy.update_animation( anim_name )
	enemy.animation_player.animation_finished.connect( _on_animation_finished )
	pass
	

## what happens when the player exits this State?
func exit() -> void:
	enemy.invulnerable = false
	enemy.animation_player.animation_finished.disconnect( _on_animation_finished )
	pass
	
	
## what happens during the _process update in this State?
func process( _delta : float) -> EnemyState: 
	if _animation_finished == true:
		return next_state
	# otherwise:
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null # return null if no next_state
	
	
## what happens during the _physics_process update in this State?
func physics( _delta : float ) -> EnemyState:
	return null


# Run when enemy's take_damage() func signals. Once damaged, change to stun state in the state machine
func _on_enemy_damaged( hurt_box: HurtBox ) -> void: 
	_damage_position = hurt_box.global_position # hurtbox inherits Node2D so has a position
	state_machine.change_state( self )
	

func _on_animation_finished( _a : String ) -> void:
	_animation_finished = true
