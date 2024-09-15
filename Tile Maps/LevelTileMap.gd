class_name LevelTileMap extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	# autoload script LevelManager can be refed globally
	LevelManager.ChangeTilemapBounds( GetTilemapBounds() )
	pass # Replace with function body.


func GetTilemapBounds() -> Array[ Vector2 ]:
	var bounds : Array[ Vector2 ] = []
	# get_used_rect is a func of TileMap to get the rectangle that contains all the tiles in tilemap. Position is the
	# tile position not pixel position (eg 32*32). rendering_quadrant_size is the size of the tile pixel size (make 
	# sure they match in Inspector). get_used_rect().position always refer to the top left corner.
	bounds.append(
		Vector2( get_used_rect().position * rendering_quadrant_size ) 
	)
	# get_used_rect().end refers to the bottom right corner.
	bounds.append(
		Vector2( get_used_rect().end * rendering_quadrant_size ) 
	)
	return bounds
