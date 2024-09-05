class_name EnemyStateDestroy extends EnemyState

const PICKUP = preload("res://Items/item_pickup/item_pickup.tscn")

@export var anim_name : String = "Destroy" # animation name can be changed in Inspector with the rest of code working
@export var knockback_speed : float = 200.0
@export var decelerate_speed : float = 10.0

@export_category("AI") # probably not needed

@export_category("Item Drops")
@export var drops : Array[ DropData ] # array size auto show in Inspector

var _damage_position : Vector2
var _direction : Vector2


## what happens when we initialize this state?
func init() -> void : # each state will be initialised in the enemy_state_machine
	enemy.enemy_destroyed.connect( _on_enemy_destroyed )
	pass


## what happens when the player enters this State?
func enter() -> void:
	enemy.invulnerable = true
	
	# opposed to _damage_pos which is hurtbox's pos
	_direction = enemy.global_position.direction_to( _damage_position )
	enemy.set_direction( _direction )
	enemy.velocity = _direction * -knockback_speed
	
	enemy.update_animation( anim_name )
	enemy.animation_player.animation_finished.connect( _on_animation_finished )
	
	disable_hurt_box() # turn off hurtbox so won't do damage once destroyed
	
	drop_items()
	pass
	

## what happens when the player exits this State?
func exit() -> void: # no code needed as enemy will be removed once destroyed
	pass
	
	
## what happens during the _process update in this State?
func process( _delta : float) -> EnemyState:
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null # return null if no next_state
	
	
## what happens during the _physics_process update in this State?
func physics( _delta : float ) -> EnemyState:
	return null


# Run when enemy's take_damage() func signals. Change to destroy state in state machine
func _on_enemy_destroyed( hurt_box : HurtBox ) -> void:
	_damage_position = hurt_box.global_position # hurtbox inherits Node2D so has a position
	state_machine.change_state( self )
	

func _on_animation_finished( _a : String ) -> void:
	enemy.queue_free()


# For disabling hurtbox so won't do damage once destroyed (i added HurtBox monitoring key in anima player)
func disable_hurt_box() -> void:
	var hurt_box : HurtBox = enemy.get_node_or_null( "HurtBox" ) # make code robust in case the enemy don't
	# have a hurtbox or name differently, only return if can find it
	if hurt_box:
		hurt_box.monitoring = false


# For drop items:
func drop_items() -> void:
	if drops.size() == 0: # some enemy don't have any drop
		return
	
	for i in drops.size():
		if drops[ i ] == null or drops[ i ].item == null:
			continue # skip the following code and jump to the next index in loop
		var drop_count : int = drops[ i ].get_drop_count() # return a number (amount of drop)
		for j in drop_count:
			# Instantiate ItemPickup (what a drop essentially is) and match drop. Cast the instantiated
			# as ItemPick.
			var drop : ItemPickup = PICKUP.instantiate() as ItemPickup
			drop.item_data = drops[ i ].item # item_data in item_pickup script gets set to match drops' item.
			
			# The drop won't appear without a parent. Give it the parent of enemy (should be where we are).
			# Destroy state only gets set when area2D (hitbox) send an signal - can't add an area2D to the
			# scene in the same call that's triggered by an area2D, so can't add child as usually. Use
			# call_deferred pass in the method in string and argument, and wait till safe to call it.
			enemy.get_parent().call_deferred( "add_child", drop)
			drop.global_position = enemy.global_position
			# rotated 1.5 = 86 deg. Velocity times range (0.9 a little slower than enemy, 1.5)
			drop.velocity = enemy.velocity.rotated( randi_range(-2, 2) ) * randf_range(0.9, 1.5)
			
	pass
