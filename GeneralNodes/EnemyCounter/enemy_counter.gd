# For checking if all enemy's cleared, then sth happens eg. drop dungen key
class_name EnemyCounter extends Node2D

signal enemies_defeated


func _ready() -> void:
	# child_exiting_tree is a signal of Node2D, passing along a Node2D. When an enemy is killed:
	child_exiting_tree.connect( _on_enemy_destroyed )
	pass


func _on_enemy_destroyed( e: Node2D ) -> void:
	if e is Enemy: # Check!
		# If there're 2, 1 gets killed, enemy_count = 2 when the signal child_exiting_tree emits.
		# So when the last one gets killed, count = 1. Shouldn't be 0. 
		if enemy_count() <= 1:
			enemies_defeated.emit() # Connected to drop_item() in ItemDropper script by Node
		
	pass


func enemy_count() -> int:
	var _count : int = 0
	for c in get_children():
		if c is Enemy:
			_count += 1
	return _count
