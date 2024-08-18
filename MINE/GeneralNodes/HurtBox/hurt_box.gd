# HurtBox being a child of Sprite2D so it can flip with sprite2D on the x-axis
class_name HurtBox extends Area2D

# can have more @export like effects
@export var damage : int = 1


func _ready():
	## when the HitBox enters the HurtBox, TakeDamage() gets called and damage gets emitted
	area_entered.connect( AreaEntered ) # area_entered is a signal of Area2D
	pass


func _process(_delta):
	pass


func AreaEntered ( a : Area2D ) -> void: # "a" can be any name
	if a is HitBox: # class name "HitBox" must be correct
		a.TakeDamage( self ) # pass in self so all of its @export var can be emitted at once, simplify code
	pass
		
