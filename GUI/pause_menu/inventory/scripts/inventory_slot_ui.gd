## Attached to InventorySlot scene, for displaying slot_data texture and quantity in UI to match Slot_data
class_name Inventory_slot_UI extends Button

var slot_data : SlotData : set = set_slot_data # whenever we set this var (in inventory_ui script 
# update_inventory func), call the set_slot_data func

@onready var texture_rect : TextureRect = $TextureRect
@onready var label : Label = $Label


func _ready() -> void:
	texture_rect.texture = null # clear texture to start with
	label.text = ""
	focus_entered.connect( item_focused ) # focus_entered is a signal of scripts extending Button (this one)
	focus_exited.connect( item_unfocused )
	pressed.connect( item_pressed ) # For using items in inventory. pressed is a signal of Button type script


func set_slot_data( value : SlotData ) -> void: # being called by set above
	slot_data = value
	if slot_data == null:
		return # ok to have empty slots
	texture_rect.texture = slot_data.item_data.texture # the texture is saved in item_data
	label.text = str( slot_data.quantity )
	

func item_focused() -> void:
	if slot_data != null: # to avoid error messages when selecting an empty slot
		if slot_data.item_data != null: # same as above
			PauseMenu.update_item_description( slot_data.item_data.description )
	pass
	

func item_unfocused() -> void:
	PauseMenu.update_item_description( "" )


func item_pressed() -> void:
	if slot_data:
		if slot_data.item_data:
			var was_used = slot_data.item_data.use() # use() is bool func, var is true or falsue
			if was_used == false: # item can't be used
				return
			slot_data.quantity -= 1 # quantity is set, triggerring set in slot_data script
			label.text = str( slot_data.quantity )
	pass
