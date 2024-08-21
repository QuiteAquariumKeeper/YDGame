extends CanvasLayer # don't need class name as the root node scene is put in auto load

@onready var animation_player : AnimationPlayer = $Control/ColorRect/AnimationPlayer


func fade_out() -> bool:
	animation_player.play("fade_out")
	await animation_player.animation_finished
	return true

func fade_in() -> bool:
	animation_player.play("fade_in")
	await animation_player.animation_finished
	return true
