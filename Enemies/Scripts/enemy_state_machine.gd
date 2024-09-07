class_name EnemyStateMachine extends Node


var states : Array[ EnemyState ]
var prev_state : EnemyState
var current_state : EnemyState


func _ready():
	process_mode = Node.PROCESS_MODE_DISABLED
	pass


func _process(delta):
	change_state( current_state.process( delta ) )
	pass


func _physics_process(delta):
	change_state( current_state.physics( delta ) )
	pass
	

func initialize( _enemy : Enemy ) -> void:
	states = []
	
	for c in get_children():
		if c is EnemyState:
			states.append( c )
	
	# differ to player, setting up each state:
	for s in states:
		s.enemy = _enemy
		s.state_machine = self
		s.init() # for each state, we will initialise it
	
	if states.size() > 0:
		change_state( states[0] )
		process_mode = Node.PROCESS_MODE_INHERIT # inherit processing from the parent. Allow us to pause game & enemies will pause with it
	pass
	
	
func change_state( new_state : EnemyState ) -> void:
	if new_state == null || new_state == current_state:
		return
		
	if current_state: # if there's a current state (when the first initialise there's no current state
		current_state.exit()
	
	prev_state = current_state
	current_state = new_state
	current_state.enter()
