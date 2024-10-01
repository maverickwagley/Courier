#EnemyProgress
#scr_gui_enemy_progress
#
extends TextureProgressBar
#
#Built-in Methods
#
func _ready() -> void:
	value = 100
# 
#Custom Methods
#
func update_enemy_progress(_waveProg):
	value = _waveProg
