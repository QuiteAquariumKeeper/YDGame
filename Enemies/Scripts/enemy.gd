class_name Enemy extends CharacterBody2D

signal direction_changed( new_direction : Vector2 )
signal enemy_damaged( hurt_box: HurtBox ) # pass in hurt_box so enemy's states will have access to hurtbox's var
signal enemy_destroyed( hurt_box: HurtBox )

const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ]

@export var hp : int = 3

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var player : Player
var invulnerable : bool = false

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
@onready var hit_box : HitBox = $HitBox
@onready var state_machine : EnemyStateMachine = $EnemyStateMachine


func _ready():
	state_machine.initialize( self )
	player = PlayerManager.player # from globalPlayerManager. Assumed player initialised before enemies
	hit_box.damaged.connect( _take_damage )
	pass


func _process(_delta):
	pass


func _physics_process( _delta ):
	move_and_slide() 
	
	
func set_direction( _new_direction : Vector2 ) -> bool: # require dir input unlike player
	direction = _new_direction
	if direction == Vector2.ZERO:
		return false
	
	var direction_id : int = int( round( ( direction + cardinal_direction * 0.1 ).angle() / TAU * DIR_4.size() ) )
	var new_dir = DIR_4[ direction_id ] # eg. DIR_4[0]
		
	if new_dir == cardinal_direction:
		return false
		
	cardinal_direction = new_dir
	direction_changed.emit( new_dir )
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true


func update_animation( state : String ) -> void:
	animation_player.play( state + "_" + anim_direction())
	pass


func anim_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif  cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"


# Run when hitbox signals
func _take_damage ( hurt_box: HurtBox ) -> void:
	# for enemy to have a little invunerable period after being hit so don't stuck in a stun loop
	if invulnerable == true:
		return
	# otherwise:
	hp -= hurt_box.damage
	if hp > 0:
		enemy_damaged.emit( hurt_box ) # pass in hurt_box so enemy's stun state have access to hurtbox's var
	else:
		enemy_destroyed.emit( hurt_box ) # emits to destory state
	


