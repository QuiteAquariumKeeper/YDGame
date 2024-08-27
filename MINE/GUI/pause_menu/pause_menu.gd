## Auto load
extends CanvasLayer

signal shown
signal hidden

@onready var button_save = $Control/HBoxContainer/Button_Save
@onready var button_load = $Control/HBoxContainer/Button_Load
@onready var item_description = $Control/ItemDescription

var is_paused : bool = false



func _ready():
	hide_pause_menu() # hide when first play
	button_save.pressed.connect( _on_save_pressed )
	button_load.pressed.connect( _on_load_pressed )
	pass


# _unhandled_input check any input that hasn't been handled by another script previously
func _unhandled_input(event : InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if is_paused == false:
			show_pause_menu()
		else :
			hide_pause_menu()
		# make the input event as handled so won't be picked up by multiple scripts
		get_viewport().set_input_as_handled()
	
	
func show_pause_menu() -> void:
	get_tree().paused = true # PauseMenu node is set to Always in Process so won't pause
	visible = true
	is_paused = true
	shown.emit() # for inventory


func hide_pause_menu() -> void:
	get_tree().paused = false
	visible = false
	is_paused = false
	hidden.emit() # for inventory
	
	
func _on_save_pressed() -> void:
	if is_paused == false: # to be safe
		return
	SaveManager.save_game()
	hide_pause_menu()
	pass


func _on_load_pressed() -> void:
	if is_paused == false: # to be safe
		return
	SaveManager.load_game()
	await LevelManager.level_load_started # that's when screen is already back, then hide menu, looks smoother
	hide_pause_menu()
	pass


func update_item_description( new_text : String ) -> void: # called in inventory_slot_ui script
	item_description.text = new_text
	
