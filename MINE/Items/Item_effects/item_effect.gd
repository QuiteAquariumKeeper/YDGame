## A generic ItemEffect Resource script, other real item effects will base on this (using use() func)
class_name ItemEffect extends Resource

# Resource type script is only a Resorce when added @export var
@export var use_descriiption : String


# used by other real item effect scripts extending this one
func use() -> void:
	pass
