class_name HitBox extends Area2D

signal damaged( hurt_box: HurtBox ) # this signal pass along the hurtbox


func _ready():
	pass


## a modular for taking damage, can drag and drop it for other entities
func TakeDamage( hurt_box: HurtBox ) -> void:
	damaged.emit( hurt_box )
