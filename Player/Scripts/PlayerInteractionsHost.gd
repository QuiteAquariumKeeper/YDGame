class_name PlayerInteractionsHost extends Node2D

@onready var player : Player = $".."



func _ready():
	player.DirectionChanged.connect( UpdateDirection ) # when player emits signal, get passed to UpdateDirection()
	pass


func UpdateDirection ( new_direction : Vector2 ) -> void:
	## match is a different way to do if statement
	match new_direction:
		Vector2.DOWN: # if the new direction is Vector2.Down
			rotation_degrees = 0
		Vector2.UP:
			rotation_degrees = 180
		Vector2.LEFT:
			rotation_degrees = 90
		Vector2.RIGHT:
			rotation_degrees = -90
		_: # default in case new direction doesn't match any
			rotation_degrees = 0
	pass
