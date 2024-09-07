extends Node2D


func _ready():
	visible = false # don't see it when run the game (the green player sprite)
	if PlayerManager.player_spawned == false:
		PlayerManager.set_player_position( global_position ) # use the global pos of this node
		# for future levels that the player wanders on to and a spawn pos has been placed, we won't move the
		# player when enters that level.
		PlayerManager.player_spawned = true


