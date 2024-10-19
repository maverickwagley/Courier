#scr_shieldbar_enemy
#
extends TextureProgressBar
#
@onready var enemy = get_parent()
#
#Built-In Functions
#
func _ready():
	value = 0
