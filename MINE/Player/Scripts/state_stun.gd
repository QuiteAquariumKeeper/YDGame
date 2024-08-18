## this state can overwirte other states ( in _player_damaged func)

class_name State_Stun extends State

@export var knockback_speed : float = 200.0
@export var decelerate_speed : float = 10.0
@export var invulnerable_duration : float = 1.0

var hurt_box : HurtBox
var direction : Vector2

var next_state : State = null

@onready var idle : State = $"../Idle"


func init() -> void:
	player.player_damaged.connect( _player_damaged )
	
 
## what happens when the player enters this State?
func Enter() -> void:
	player.animation_player.animation_finished.connect( _animation_finished )
	
	direction = player.global_position.direction_to( hurt_box.global_position )
	player.velocity = direction * -knockback_speed
	player.SetDirection() # !!!!!!!!!!
	
	player.UpdateAnimation( "Stun" ) # set direction first then play stun so stun anima can face correct dir
	player.make_invulnerable( invulnerable_duration )
	player.effect_animation_player.play( "Damaged" ) # effect_animation_player is the Node
	pass
	

## what happens when the player exits this State?
func Exit() -> void:
	next_state = null # so func Process can be set to null instead of idle which plays right after stun anima finishes
	player.animation_player.animation_finished.disconnect( _animation_finished )
	pass
	
	
## what happens during the _process update in this State?
func Process( _delta : float ) -> State: 
	player.velocity -= player.velocity * decelerate_speed * _delta # decelerate during knockback
	return next_state

	
## what happens during the _physics_process update in this State?
func Physics( _delta : float ) -> State:
	return null


## what happens with input events in this State?
func HandleInput( _event: InputEvent ) -> State:
	return null


func _player_damaged( _hurt_box : HurtBox ) -> void:
	hurt_box = _hurt_box
	state_machine.change_state( self ) # so this stun state can overwrite other states
	pass


func _animation_finished( _a : String ) -> void:
	next_state = idle # becomes idle state as soon as stun anima finishes
