class_name Plant extends Node2D

var is_cut : bool = false

@onready var persistent_data_is_cut = $"PersistentData-IsCut"


# Called when the node enters the scene tree for the first time.
func _ready():
	$HitBox.damaged.connect( TakeDamage ) # if want to use $HitBox more than once, put on top as @onready
	
	# For data persistence:
	persistent_data_is_cut.data_loaded.connect( set_plant_state )
	set_plant_state()
	
	pass # Replace with function body.


func set_plant_state() -> void:
	is_cut = persistent_data_is_cut.value # is a bool
	if is_cut:
		queue_free()
	else:
		return
	

func TakeDamage ( _hurt_box : HurtBox ) -> void: # _damage underscore means might not use it
	persistent_data_is_cut.set_data()
	
	queue_free() # remove the Plant Node
	pass
