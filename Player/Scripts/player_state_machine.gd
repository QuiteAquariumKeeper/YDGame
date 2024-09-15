class_name PlayerStateMachine extends Node


var states : Array[ State ]
var prev_state : State
var current_state : State


func _ready():
	process_mode = Node.PROCESS_MODE_DISABLED # disable process_mode when first load this script
	pass


func _process(delta):
	change_state( current_state.Process( delta ) ) # current_state.Process( delta ) returns either a null or a state
	pass


func _physics_process(delta):
	change_state( current_state.Physics( delta ) ) 
	pass


func _unhandled_input(event): # built-in func
	change_state( current_state.HandleInput( event ) )
	pass

	

func Initialize( _player : Player ) -> void: # for setting up state machine
	states = []
	
	# get all of our states within our state machine
	for c in get_children(): # get_children() returns an array of nodes (children of StateMachine)
		if c is State:
			states.append(c) # add c to state array
	
	if states.size() == 0: # check if there's state in our statemachine
		return
	
	# otherwise:
	states[0].player = _player # _player is what being passed in Initialize func
	states[0].state_machine = self
	
	# initialize each state:
	for state in states:
		state.init()
		
	change_state( states[0] ) # change state to the first state in array
	process_mode = Node.PROCESS_MODE_INHERIT #???????????????
		
		

func change_state( new_state : State ) -> void: # input is the new state we want to change to
	# check if the new state is a valid state, and not the same as the current state
	if new_state == null || new_state == current_state:
		return
		
	# when there's a new state passed in:
	if current_state: # if there's a current state (when the first initialise there's no current state
		current_state.Exit()
	
	prev_state = current_state
	current_state = new_state
	current_state.Enter()




