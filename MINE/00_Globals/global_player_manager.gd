## auto load, don't need class name
extends Node

# drag & dropped the player scene from filesystem. This is the reference to create an instance of the player
# in different levels
const PLAYER = preload("res://Player/player.tscn")

var player : Player
var player_spawned : bool = false # false by default


func _ready() -> void:
	add_player_instance()
	
	# fail safe for levels where we don't have a spawn point:
	await get_tree().create_timer( 0.2 ).timeout
	player_spawned = true # after 0.2s if a player hasn't been spawned (cos don't need to), set it to true


func add_player_instance() -> void:
	player = PLAYER.instantiate() # create a new instance of player
	
	# add the player to the scene somewhere. Added as a child to the root scene (so on the same layer as the 
	# playground (eg), so due to Y sort Enabled, the spawned player will be behind plants etc. So use 
	# set_as_parent func
	add_child( player )
	pass


func set_player_position( _new_pos : Vector2 ) -> void:
	player.global_position = _new_pos
	pass


func set_as_parent( _p : Node2D ) -> void:
	# remove player's current parent if there's one:
	if player.get_parent(): # if player has a parent
		player.get_parent().remove_child( player )
	_p.add_child( player ) # give player a new parent _p


func unparent_player( _p : Node2D ) -> void:
	_p.remove_child( player ) # won't work if player is not a child of this node
