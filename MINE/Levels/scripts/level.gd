##for making the spawned player (instantiated from global PlayerManager) a child of Playground/Level so Y sort works
class_name Level extends Node2D


func _ready():
	self.y_sort_enabled = true # to be safe
	PlayerManager.set_as_parent( self )


