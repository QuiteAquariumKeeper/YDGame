class_name PressurePlate extends Node2D


signal activated
signal deactivated

var bodies : int = 0 # No. of collision bodies on top
var is_active : bool = false
var off_rect : Rect2 # Track where out sprite sheet needs to be

@onready var area_2d : Area2D = $Area2D
@onready var audio : AudioStreamPlayer2D = $AudioStreamPlayer2D # it's a player, not an acutal stream.
# Typed @onready and dragged the audio file from folder to preload().Can use @export to (so no preload)
@onready var audio_activate : AudioStream = preload("res://Interactable/Dungen/lever-01.wav") 
@onready var audio_deactivate : AudioStream = preload("res://Interactable/Dungen/lever-02.wav")
@onready var sprite : Sprite2D = $Sprite2D


func _ready() -> void:
	area_2d.body_entered.connect( _on_body_entered )
	area_2d.body_exited.connect( _on_body_exited )
	# Sprite Inspector-Region->Rect. Region of atlas texture to display. (deactivated plate texture atm)
	off_rect = sprite.region_rect 
	pass


func _on_body_entered( _b : Node2D) -> void:
	# Can't just "activated.emit()", as if both player and statue on, and one leaves, deactivate signal
	# can be fired off.
	bodies += 1
	check_is_activated()
	pass


func _on_body_exited( b : Node2D) -> void:
	bodies -= 1
	check_is_activated()
	pass


func check_is_activated() -> void:
	if bodies > 0 and is_active == false: # Don't want to double activate if already is
		is_active = true
		# change sprite atlas texture to "activated" by -32 on x:
		sprite.region_rect.position.x = off_rect.position.x - 32
		play_audio( audio_activate )
		activated.emit()
	elif bodies <= 0 and is_active == true: # Not "else" as there're other scenarios 
		is_active = false
		sprite.region_rect.position.x = off_rect.position.x
		play_audio( audio_deactivate )
		deactivated.emit()
	pass
		

func play_audio( _stream : AudioStream ) -> void:
	audio.stream = _stream
	audio.play()
