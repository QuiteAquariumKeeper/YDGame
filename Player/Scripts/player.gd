# player has to be at the top of the scene tree (before enemies)
class_name Player extends CharacterBody2D # name my script Player 

signal DirectionChanged ( new_direction : Vector2 ) # For PlayerInteractionHost. signal will emit the new direction
signal player_damaged ( hurt_box : HurtBox)

const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ] # an array of 4 costants

var cardinal_direction : Vector2 = Vector2.DOWN # my default direction is down
var direction : Vector2 = Vector2.ZERO # zero on x & y axis

var invulnerable : bool = false
var hp : int = 6
var max_hp : int = 6


@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var effect_animation_player : AnimationPlayer = $EffectAnimationPlayer
@onready var hit_box : HitBox = $HitBox
@onready var sprite : Sprite2D = $Sprite2D
@onready var state_machine : PlayerStateMachine = $StateMachine


func _ready():
	PlayerManager.player = self
	state_machine.Initialize(self) # slef is player
	hit_box.damaged.connect( _take_damage )
	update_hp(99) # give player full health once instanticated
	pass


func _process( _delta ):
	#direction.x = Input.get_action_strength("right") - Input.get_action_strength("left") # player pressing right = 1
	#direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized() # ensure diagnal speed equals stright walking speed
	pass
	
	
func _physics_process( _delta ): # called every physics take
	move_and_slide() # method built in CharactorBody2D


# Gets called in states eg. walk. if direction changes, return true.
func SetDirection() -> bool:
	if direction == Vector2.ZERO:
		return false
	
	var direction_id : int = int( round( ( direction + cardinal_direction * 0.1 ).angle() / TAU * DIR_4.size() ) ) # get the direction 
	# angle 360-0 and covert to a number and * by the size of the array, then round to an integer. Gives 0 - 3. 
	# 'direction + cardinal_direction * 0.1' is to skew a little to the direction i was facing first (cardi is already facing, direction
	# is the new direction)
	var new_dir = DIR_4[ direction_id ] # eg. DIR_4[0] ie. the first DIR which is RIGHT
		
	if new_dir == cardinal_direction:
		return false
		
	cardinal_direction = new_dir
	DirectionChanged.emit( new_dir ) # emit new direction for interactions
	# for flipping side (can flip with child object:
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1 # 1 facing right is my original set scale
	return true


# Called in states
func UpdateAnimation( state : String ) -> void:
	animation_player.play( state + "_" + AnimDirection() )
	pass


func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif  cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"


func _take_damage( hurt_box : HurtBox ) -> void:
	if invulnerable == true:
		return # do nothing and end this func
	
	update_hp( -hurt_box.damage)
	if hp > 0:
		player_damaged.emit( hurt_box ) # emit to player stun state
	else:
		player_damaged.emit( hurt_box )
		update_hp(99) # reset hp to 99 so don't die
	pass


# can be used for healing too
func update_hp( delta : int ) -> void:
	hp = clampi( hp + delta, 0, max_hp ) # clamp to int
	PlayerHud.update_hp( hp, max_hp ) # calling autoload scene script PlayerHud
	pass


func make_invulnerable( _duration : float = 1.0 ) -> void: # default = 1s, so can be called without passing anything in
	invulnerable = true
	hit_box.monitoring = false
	
	#create a timer and wait till time out.
	await get_tree().create_timer( _duration ).timeout # get_tree is tet the root of our scene
	
	invulnerable = false
	hit_box.monitoring = true
	pass
