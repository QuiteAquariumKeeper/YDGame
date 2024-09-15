class_name ItemEffectHeal extends ItemEffect

@export var heal_amount : int = 1
@export var audio : AudioStream


# override the use() func in the generice ItemEffect script. Being called in item_data script
func use() -> void:
	PlayerManager.player.update_hp( heal_amount )
	# playing sound func is set in PauseMenu as it's auto load so already have access to it
	PauseMenu.play_audio( audio )
	
