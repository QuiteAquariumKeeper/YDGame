class_name PlayerCamera extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	LevelManager.TileMapBoundsChanged.connect( UpdateLimits )
	# force it to run when first open the script (in case scripts run in different orders that won't receive signal first
	UpdateLimits( LevelManager.current_tilemap_bounds ) 
	pass # Replace with function body.


func UpdateLimits ( bounds : Array[ Vector2 ] ) -> void: # Bounds array has 2 vectors: top left and bottom right coor
	if bounds == []:
		return # to prevent errors
	limit_left = int( bounds[0].x ) # Limit in Inspector is integers
	limit_top = int( bounds[0].y )
	limit_right = int( bounds[1].x )
	limit_bottom = int( bounds[1].y )
	pass
