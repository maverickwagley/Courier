#scr_gui_slot
#
extends Control
#
@export var slot_num: int
@onready var background_sprite: = $NinePatchRect
@onready var form_sprite: = $CenterContainer/Sprite2D
#
#Custom Methods
#
func update():
	form_sprite.frame = slot_num
#
func _on_slot_button_down():
	print_debug("Slot Button Down")
