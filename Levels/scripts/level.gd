## for making the spawned player (instantiated from global PlayerManager) a child of the level root node
## (Playground/01/02/03) so Y sort works
class_name Level extends Node2D


func _ready():
	self.y_sort_enabled = true # to be safe
	PlayerManager.set_as_parent( self ) # making level script (attached to 01/02/03) parent of player
	# remove current level when level_load_started during level transition
	LevelManager.level_load_started.connect( _free_level )
	

# for removing the current level during level transition
func _free_level() -> void:
	# remove child Player before removing the current level so we still have the player
	PlayerManager.unparent_player( self )
	queue_free() # remove level
