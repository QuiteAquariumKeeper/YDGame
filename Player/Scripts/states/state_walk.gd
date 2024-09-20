class_name State_Walk extends State # duplicated from State so extends from State

@export var move_speed : float = 250.0 # show in Inspector

@onready var idle : State = $"../Idle"
@onready var attack : State = $"../Attack"

 
## what happens when the player enters this State?
func Enter() -> void:
	player.UpdateAnimation("Walk")
	pass
	

## what happens when the player exits this State?
func Exit() -> void:
	pass
	
## what happens during the _process update in this State?
func Process( _delta : float) -> State: 
	if player.direction == Vector2.ZERO:
		return idle
		
	player.velocity = player.direction * move_speed
	
	# update anima when change direction during walking:
	if player.SetDirection():  # SetDirection() returns a bool: if direction changes (ie true), update anima:
		player.UpdateAnimation("Walk")
	return null # either return a state or null

	
## what happens during the _physics_process update in this State?
func Physics( _delta : float ) -> State:
	return null


## what happens with input events in this State?
func HandleInput( _event: InputEvent ) -> State:
	if _event.is_action_pressed("attack"):
		return attack
	if _event.is_action_pressed("interact"):
		PlayerManager.interact_pressed.emit()
	return null
