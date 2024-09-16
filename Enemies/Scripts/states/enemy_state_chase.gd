class_name EnemyStateChase extends EnemyState


@export var anim_name : String = "Chase" # name can change in Inspector with the rest of code working
@export var chase_speed : float = 40.0
@export var turn_rate : float = 0.25 # rate for goblin to turn to chase player

@export_category("AI")
@export var vision_area : VisionArea
@export var attack_area : HurtBox # We got 2 hurtbox so better assign (here's choosing AttackHurtBox)
@export var state_aggro_duration : float = 0.5 # how long it stays in chase state
@export var next_state : EnemyState

var _timer : float = 0.0
var _direction : Vector2
var _can_see_player : bool = false



## what happens when we initialize this state?
func init() -> void:
	if vision_area:
		vision_area.player_entered.connect( _on_player_enter )
		vision_area.player_exited.connect( _on_player_exit )
	pass


## what happens when the player enters this State?
func enter() -> void:
	_timer = state_aggro_duration
	enemy.update_animation( anim_name )
	
	if attack_area:
		attack_area.monitoring = true
	pass
	

## what happens when the player exits this State?
func exit() -> void:
	if attack_area:
		attack_area.monitoring = false
		_can_see_player = false
	pass
	
	
## what happens during the _process update in this State?
func process( _delta : float) -> EnemyState:
	# The new direction is towards the player when starts to chase
	var new_dir : Vector2 = enemy.global_position.direction_to( PlayerManager.player.global_position)
	# Lerp() is linear interpolation of goblin's original dir to the new chase dir to make it smooth.
	# Lerping from the current _direction to the new_dir at weight turn_rate.
	_direction = lerp( _direction, new_dir, turn_rate )
	enemy.velocity = _direction * chase_speed
	if enemy.set_direction( _direction ): # It's a bool - when it's true:
		 # update anime to match the new direction (eg. chase from down to left)
		enemy.update_animation( anim_name )
	
	if _can_see_player == false: # Trigger by _on_player_exit() below (player exiting vision)
		_timer -= _delta
		if _timer < 0:
			return next_state # Not chasing anymore when timer hits 0
	else:
		_timer = state_aggro_duration
		
	return null # return null if no next_state
	
	
## what happens during the _physics_process update in this State?
func physics( _delta : float ) -> EnemyState:
	return null


func _on_player_enter() -> void:
	_can_see_player = true
	
	# Prevent stun state being interruptted:
	if state_machine.current_state is EnemyStateStun:
		return
	
	state_machine.change_state( self ) # state_machine is variable from enemy_state script
	pass


func _on_player_exit() -> void:
	_can_see_player = false # Triggering if ... == false code in process() above
	pass
