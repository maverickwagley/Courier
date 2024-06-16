extends Control

@export var slot_num: int
@onready var background_sprite: = $NinePatchRect
@onready var form_sprite: = $CenterContainer/Sprite2D

func update():
	form_sprite.frame = slot_num
	#if !item:
		#background_sprite.frame = 0
		#item_sprite.visible = false
	#else:
		#background_sprite.frame = 1
		#item_sprite.visible = true
		#item_sprite.texture = item.texture


func _on_slot_button_down():
	print_debug("Slot Button Down")
