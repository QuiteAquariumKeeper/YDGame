class_name SlotData extends Resource

@export var item_data : ItemData # a resource we created
@export var quantity : int = 0 : set = set_quantity # getting displayed in inventory_slot_ui script


# when item used up
func set_quantity( value : int ) -> void:
	quantity = value
	if quantity < 1:
		emit_changed() # critical change (reach 0) so emit change (a signal within Resource type script)
		# connected to connect_slot() and within add item fucn
