class_name EnemyState extends Node


## Stores a ref to the enemy that this state belongs to
var enemy : Enemy # didn't make this static bc if there're more enemies, want the script to affect all on the screen. This var is per class
var state_machine : EnemyStateMachine


## what happens when we initialize this state?
func init() -> void :
	pass


## what happens when the player enters this State?
func enter() -> void:
	pass
	

## what happens when the player exits this State?
func exit() -> void:
	pass
	
	
## what happens during the _process update in this State?
func process( _delta : float) -> EnemyState: 
	return null # either return a state or null
	
	
## what happens during the _physics_process update in this State?
func physics( _delta : float ) -> EnemyState:
	return null


