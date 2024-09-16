## Used for goblin to detect if player's in sight (and chase) 
class_name VisionArea extends Area2D

signal player_entered()
signal player_exited()


func _ready() -> void:
	body_entered.connect( _on_body_enter )
	body_exited.connect( _on_body_exit )
	
	# Need to check if we have enemy as a parent, then connect to it - This way don't have to
	# manually assign the enemy to this script (As can't directly use Enemy, cannot found)
	var p = get_parent()
	if p is Enemy:
		p.direction_changed.connect( _on_direction_change )
	pass


func _on_body_enter( _b: Node2D ) -> void:
	if _b is Player:
		player_entered.emit() # Recieved in chase state
	pass


func _on_body_exit( _b : Node2D ) -> void:
	if _b is Player:
		player_exited.emit() # Recieved in chase state
	pass
	

# To connect vision_area to enemy's direction change
func _on_direction_change( new_direction : Vector2 ) -> void:
	match new_direction:
		Vector2.DOWN: # if new_dir matches Vector2.DOWN:
			rotation_degrees = 0
		Vector2.UP:
			rotation_degrees = 180
		Vector2.LEFT:
			rotation_degrees = 90
		Vector2.RIGHT:
			rotation_degrees = -90
		_:
			rotation_degrees = 0
	pass
	
