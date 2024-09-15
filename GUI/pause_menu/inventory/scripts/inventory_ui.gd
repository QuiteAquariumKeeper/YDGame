## Attached to GridContainer. Selected player_inventory in Inspector so shows player's inventory. Fpr 
## displaying what's in InventoryData
class_name InventoryUI extends Control

# ref the inventory_slot scene so when this script loads, can instantiate more slots as we need
const INVENTORY_SLOT = preload("res://GUI/pause_menu/inventory/inventory_slot.tscn") 

var focus_index : int = 0

@export var data : InventoryData # InventoryData is a script that extends Resource, need to select
# player_inventory in Inspector


func _ready() -> void:
	PauseMenu.shown.connect( update_inventory )
	PauseMenu.hidden.connect( clear_inventory )
	clear_inventory() # clear inventory to start the game with 
	data.changed.connect( on_inventory_changed ) # from InventoryData slot_changed() for when item used up
	pass


func clear_inventory() -> void:
	for c in get_children(): # get all the children & loop thru them
		c.queue_free()
	 

# func needs to create InventorySlot buttons, add them to CridContainter, and add slot data (s):
func update_inventory( i : int = 0 ) -> void: # default to 0 so grab focus of the first item
	for s in data.slots: # data in inspector is selected as player-inventory so have 10 slots here
		var new_slot = INVENTORY_SLOT.instantiate() # instantiate new INVENTORY_SLOT so they match InventoryData
		add_child( new_slot ) # add new_slot (InventorySlot button) as a child to this script (GridContainer)
		
		# s is each SlotData in the InventoryData array. Setting the SlotData in the instantiated scene 
		# IventorySlot to s, triggering set() in its script (inventory_slot_ui)
		new_slot.slot_data = s
		new_slot.focus_entered.connect( item_focused ) # when new_slot gained focus, emit signal
	
	await get_tree().process_frame # wait for UI to update. focus won't work if removed
	get_child( i ).grab_focus() # i = 0 if not given


# for making focus work once an item used up
func item_focused() -> void:
	for a in get_child_count(): # get..count() give the No. of children. Need to get the index of them
		if get_child( a ).has_focus():
			focus_index = a
			#return # used by Michael
		pass


# update inventory when received signal about item used up ( so need to remove that slot from ui)
func on_inventory_changed() -> void:
	var i = focus_index # Stores focus_index first. this line stay before clear & update_inventory() so 
	# the focus stays when item used up (or focus will go to the first item in inventory)
	
	clear_inventory()
	update_inventory( i ) # feed the focus_index of the item that was just used up
	
