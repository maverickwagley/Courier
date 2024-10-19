#scr_healthbar_enemy
#
extends TextureProgressBar
#
@onready var enemy = get_parent()
#
#Built-In Functions
#
func _ready():
	value = 100
