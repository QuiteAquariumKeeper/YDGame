## A generic ItemData Resource script attached to other real items eg. gem
class_name ItemData extends Resource

@export var name : String = ""
@export_multiline var description : String = ""
@export var texture : Texture2D # sth to display in our inventory

@export_category( "Item Use Effects" )
@export var effects : Array[ ItemEffect ] # any resource extending ItemEffect can go in here. can have multiple
# effects eg. invunerability


func use() -> bool: # bool to check if the item has any effect (eg. gem doesn't)
	if effects.size() == 0:
		return false
	
	for e in effects:
		if e: # check to ensure there's an effect in the Effets slot
			e.use()
	return true
		
