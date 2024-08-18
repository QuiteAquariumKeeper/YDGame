class_name State_Idle extends State # duplicated from State so extends from State

@onready var walk : State = $"../Walk"
@onready var attack : State = $"../Attack"

 
## what happens when the player enters this State?
func Enter() -> void:
	player.UpdateAnimation("Idle")
	pass
	

## what happens when the player exits this State?
func Exit() -> void:
	pass
	
## what happens during the _process update in this State?
func Process( _delta : float) -> State: 
	if player.direction != Vector2.ZERO: # player pressing a direction
		return walk
	player.velocity = Vector2.ZERO
	return null # either return a state or null

	
## what happens during the _physics_process update in this State?
func Physics( _delta : float ) -> State:
	return null


## what happens with input events in this State?
func HandleInput( _event: InputEvent ) -> State:
	if _event.is_action_pressed("attack"):
		return attack
	return null
