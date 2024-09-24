# For pushing statue in dungen
extends Area2D

func _ready() -> void:
	body_entered.connect( _on_body_entered ) # Monitoring a body (statue's, RigidBody2D) 
	body_exited.connect( _on_body_exited )
	pass


func _on_body_entered( b : Node2D ) -> void:
	if b is PushableStatue:
		if PlayerManager.player.direction == Vector2.ZERO: # Added myself (and line below)
			b.push_direction = -b.global_position.direction_to( PlayerManager.player.global_position )
		else:
			b.push_direction = PlayerManager.player.direction
	pass


func _on_body_exited( b : Node2D ) -> void:
	if b is PushableStatue:
		b.push_direction = Vector2.ZERO
	pass
