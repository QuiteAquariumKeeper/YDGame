# script attached to autoload scene PlayerHud, don't need class name (auto load is registered at the root)
extends CanvasLayer

var hearts : Array[ HeartGUI ] = [] # an array of 20 HeartGUI


func _ready():
	for child in $Control/HFlowContainer.get_children(): # iterate all children in the HFlowContainer
		if child is HeartGUI: # should be all HeartGUI but check just in case
			hearts.append( child )
			child.visible = false # don't show 20 heart by default, need to show correct no. hearts when first instantiate player
	pass


func update_hp( _hp : int, _max_hp : int) -> void: # max_hp is how many hearts to display when first instantiate
	update_max_hp( _max_hp ) # make sure we have enough hearts available
	for i in _max_hp:
		update_heart( i, _hp )
		pass
	pass


func update_heart( _index : int, _hp : int ) -> void: # need to know which heart we're looking at and hp, so they are inputs
	# want _value to be between 0-2, in line with HeartGUI script. If hp = 3, should have 3 hearts, first heart index = 0
	# and its _value=2 (clamped) so showing 3rd frame (full heart); 2nd heart index =1, _value=1 so showing 2nd frame(half heart)
	var _value : int = clampi( _hp - _index * 2, 0, 2 ) 
	hearts[ _index ].value = _value # index=0, grab the first heart and set its value to _value which is what frame
	pass


func update_max_hp( _max_hp : int ) -> void:
	var _heart_count : int = roundi( _max_hp * 0.5 ) # will round up. counting how many hearts to show
	for i in hearts.size():
		if i < _heart_count: # if use <= it'll show a empty extra heart why???????????????
			hearts[ i ].visible = true
		else:
			hearts[ i ].visible = false
	pass
