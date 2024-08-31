class_name State_Attack extends State # duplicated from State so extends from State

## Don't want the player to leave attack state until it's completed (unlike walk or idle). Can use time or animation player
var attacking : bool = false # false as default = playing not attacking

@export var attack_sound : AudioStream
@export_range(1,20,0.5) var decelerate_speed : float = 5.0 # range of 1-20 with 0.5 increment

@onready var animation_player : AnimationPlayer = $"../../AnimationPlayer"
@onready var attack_anim : AnimationPlayer = $"../../Sprite2D/AttackEffectsSprite/AnimationPlayer"
@onready var audio : AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"


@onready var idle : State = $"../Idle"
@onready var walk : State = $"../Walk"
@onready var hurt_box : HurtBox = %AttackHurtBox # it's made unique so if it's moved around the scene tree it still can be refed


 
## what happens when the player enters this State?
func Enter() -> void:
	player.UpdateAnimation("Attack")
	attack_anim.play( "Attack_" + player.AnimDirection() ) # for attack effects
	## Using signal to connect to our func EndAttack. animation_finished is a signal in animation player
	animation_player.animation_finished.connect( EndAttack ) # as soon as the anima playing finishes, a signal fires off to EndAttack
	
	## the node AudioStreamerPlayer2D doesnt have a stream in the inspector, so need to set by script:
	audio.stream = attack_sound
	audio.pitch_scale = randf_range( 0.9, 1.1 ) # play random pitch from 0.9-1.1
	audio.play()
	
	attacking = true
	
	await get_tree().create_timer( 0.075 ).timeout # wait 0.075s before running next script (remove hitbox)
	#if attacking == true: # added by me to stop hurtbox from staying on when attack & get stunned at the same time
	hurt_box.monitoring = true
	
	await get_tree().create_timer( 0.5 ).timeout # added myself
	hurt_box.monitoring = false # added myself
	
	pass
	

## what happens when the player exits this State?
func Exit() -> void:
	animation_player.animation_finished.disconnect( EndAttack ) # disconnect when not in attack state to remove bug
	attacking = false # set it to false when exit attack to avoid error
	
	hurt_box.monitoring = false
	pass
	
## what happens during the _process update in this State?
func Process( _delta : float) -> State: 
	player.velocity -= player.velocity * decelerate_speed * _delta # when attack set velocity to decrease
	
	## as soon as the attack anima finishes, below codes run:
	if attacking == false: # ie attack has finished. 2 "=" for comparing
		if player.direction == Vector2.ZERO:
			return idle
		else :
			return walk
	return null

	
## what happens during the _physics_process update in this State?
func Physics( _delta : float ) -> State:
	return null


## what happens with input events in this State?
func HandleInput( _event: InputEvent ) -> State:
	return null


func EndAttack( _newAnimName : String ) -> void: # when signal animation_finished fires it passes a parameter _newAnimName
	attacking = false
