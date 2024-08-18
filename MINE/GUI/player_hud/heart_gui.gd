class_name HeartGUI extends Control


@onready var sprite = $Sprite2D

var value : int = 2 : # using integer in hp so can't have 0.5. 2 = full heart, 1 = half
# set & get method:
	set( _value ): # whenever the value gets set to a new one, proceed below (like a func)
		value = _value
		update_sprite()


# update frame for hearts
func update_sprite() -> void:
	sprite.frame = value # happen to be empty/half/full heart = no. frame
