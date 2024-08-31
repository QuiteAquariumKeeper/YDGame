## use this script (extends Resource) to create resources (eg. player_inventory) in inventory folder
## Used to determine if an item can be added to the inventory
class_name InventoryData extends Resource

@export var slots : Array[ SlotData ]


func _init() -> void: # = _ready() func in Resource type script, run when Resource initialise
	connect_slots()
	pass

# default return faluse, only true when conditions met (max quantity and items that are un-stackable not set)
# Being called in item_pickup script. "int=1" is optional argument, is 1 if don't specify
func add_item( item : ItemData, count : int = 1 ) -> bool:
	# loop thru non-empty slots and stack if there's an existing item that match
	for s in slots: 
		if s: # if there's an existing SlotData in slots
			if s.item_data == item:
				s.quantity += count
				return true
	
	# if no existing to stack as checked above, add to empty slots:
	for i in slots.size(): # if size = 10, i = 0-9
		if slots[ i ] == null:
			var new = SlotData.new() # create a new SlotData, (function of a Resource)
			new.item_data = item
			new.quantity = count
			slots[ i ] = new # assign "new" to the empty slot
			new.changed.connect( slot_changed) # whenever create a new slot, connect changed to slot_changed
			return true
	
	print( " inventory full")
	return false


func connect_slots() -> void:
	for s in slots:
		if s:
			s.changed.connect( slot_changed ) # for the existing items in slots. Only connect when one of them
			# quantity reaches 0
	

# clear slot when item used up
func slot_changed() -> void:
	for s in slots: # update the whole inventory - easier
		if s:
			if s.quantity < 1:
				s.changed.disconnect( slot_changed )
				var index = slots.find( s ) # find the index of that slot in the array
				slots[ index ] = null
				emit_changed() # received in inventory_ui script. Slot removed but still displying there
