## use this script (extends Resource) to create resources (eg. player_inventory) in inventory folder
class_name InventoryData extends Resource

@export var slots : Array[ SlotData ]


# can add items to inventory by script
func add_item() -> void:
	pass
