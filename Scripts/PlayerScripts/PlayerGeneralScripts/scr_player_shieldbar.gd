#scr_player_shieldbar
#
extends TextureProgressBar
#
@onready var player = $"../.."
#
#Built-in Functions
#
func _ready() -> void:
	value = player.shield * 100 / player.max_shield
#
#Custom Functions
#
func update() -> void:
	#CM: Player > apply_damage()
	if player.shield > player.max_shield:
		player.shield = player.max_shield
	value = player.shield * 100 / player.max_shield
