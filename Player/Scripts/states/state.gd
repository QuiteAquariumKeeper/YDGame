## This State script is like a blueprint, all other States should have the same structure

class_name State extends Node

## stores a ref to the player that this State belongs to
static var player: Player # static var is shared among all instances of the script that extend State (in the first line)
static var state_machine : PlayerStateMachine


func _ready():
	pass


## what happens when we initialize this State?
func init(): # No Underscore _ !!!!!!!!!!!!!!
	pass
	

## what happens when the player enters this State?
func Enter() -> void:
	pass
	

## what happens when the player exits this State?
func Exit() -> void:
	pass
	
## what happens during the _process update in this State?
func Process( _delta : float) -> State: 
	return null # either return a state or null
	
## what happens during the _physics_process update in this State?
func Physics( _delta : float ) -> State:
	return null


## what happens with input events in this State?
func HandleInput( _event: InputEvent ) -> State:
	return null
