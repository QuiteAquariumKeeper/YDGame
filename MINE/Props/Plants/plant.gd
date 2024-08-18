class_name Plant extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$HitBox.damaged.connect( TakeDamage ) # if want to use $HitBox more than once, put on top as @onready
	pass # Replace with function body.


func TakeDamage ( _hurt_box : HurtBox ) -> void: # _damage underscore means might not use it
	queue_free() # remove the Plant Node
	pass
