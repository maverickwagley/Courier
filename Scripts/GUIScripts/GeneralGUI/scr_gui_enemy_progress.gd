#scr_gui_enemy_progress
#
extends TextureProgressBar
#
var forces_progress = preload("res://Sprites/GUISprites/EnemyGUI/spr_gui_enemy_forces_radial_fill.png")
var prewave_progress = preload("res://Sprites/GUISprites/EnemyGUI/spr_gui_enemy_prewave_radial_fill.png")
#
#Built-in Functions
#
func _ready() -> void:
	value = 100
# 
#Custom Functions
#
func update_enemy_progress(_waveProg):
	set_progress_texture(forces_progress)
	value = _waveProg
#
func update_prewave_progress(_prewaveProg):
	set_progress_texture(prewave_progress)
	value = _prewaveProg
