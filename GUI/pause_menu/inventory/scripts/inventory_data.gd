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
			s.changed.connect( slot_changed ) # for the existing items in slots. Only connect when one of the
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

#---------------------------------------------------------------------------------------------------------
# For saving:
## Gather the inventory into an array (called & to be saved in dict in SaveManager)
func get_save_data() -> Array:
	var item_save : Array = []
	for i in slots.size(): # i=0-9 if size is 10
		item_save.append( item_to_save( slots[i] ) ) # take out what's being appended to a new func to breakdown
	return item_save

## Convert each inentory item into a dict (to be added to the array above)
func item_to_save( slot : SlotData ) -> Dictionary:
	var result = { item_path = "", quantity = 0 } # a {} line in dict items array. item_path is resource path
	if slot != null:
		result.quantity = slot.quantity
		if slot.item_data != null:
			result.item_path = slot.item_data.resource_path # path to the gem resource eg
	return result


# For loading:
## called in load func in SaveManager. Pass in dict items array
func parse_save_data( save_data: Array ) -> void:
	# if resize player inventory size, might need to adjust to check for size changes!!!
	var array_size = slots.size() # keep track of slots size (eg 10) that we give before run game
	slots.clear() # size = 0
	slots.resize( array_size ) # resize to 10 (eg), but all are null which is what we need
	for i in save_data.size():
		slots[ i ] = item_from_save( save_data[ i ] ) # pass in a {} line in dict items
		
	connect_slots() # all new slot_data get connected (for focus stay valid when item used up)
	pass

## Convert each dict line in items ( {item_path, quantity} ) into a slot_data:
func item_from_save( save_object : Dictionary ) -> SlotData:
	if save_object.item_path == "": # item is resource path
		return null # return null so the slot will be empty
	var new_slot : SlotData = SlotData.new() # create a new empty slot
	new_slot.item_data = load( save_object.item_path ) # path to the item last saved (in item_to_save func)
	new_slot.quantity = int(save_object.quantity) # quantity is a string in dict
	return new_slot

#----------------------------------------------------------------

# For using eg. dungen key (in locked_door script)
func use_item( item : ItemData, count : int = 1 ) -> bool:
	for s in slots:
		if s: # Check if this slot is not null (empty), i.e. there's an item in it
			if s.item_data == item and s.quantity >= count:
				s.quantity -= count
				return true
	return false
