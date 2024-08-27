# Attached to GridContainer
class_name InventoryUI extends Control

# ref the inventory_slot scene so when this script loads, can instantiate more slots as we need
const INVENTORY_SLOT = preload("res://GUI/pause_menu/inventory/inventory_slot.tscn") 

@export var data : InventoryData # InventoryData is a script that extends Resource, need to select
# player_inventory in Inspector


func _ready() -> void:
	PauseMenu.shown.connect( update_inventory )
	PauseMenu.hidden.connect( clear_inventory )
	clear_inventory() # clear inventory to start the game with 
	pass


func clear_inventory() -> void:
	for c in get_children(): # get all the children & loop thru them
		c.queue_free()
	 

# func needs to create InventorySlot buttons, add them to CridContainter, add slot data:
func update_inventory() -> void:
	for s in data.slots:
		var new_slot = INVENTORY_SLOT.instantiate()
		add_child( new_slot ) # add new_slot as a child to this script which is GridContainer
		new_slot.slot_data = s # s is each SlotData. Setting the SlotData, triggering set() in inventory_slot_ui
	
	get_child( 0 ).grab_focus() # grab focus of the first item in inventory
	
