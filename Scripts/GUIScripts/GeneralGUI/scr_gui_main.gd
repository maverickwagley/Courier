#scr_gui_main
#
extends CanvasLayer
#
@onready var inventory = $InventoryGUI 
#
#Built-In Functions
#
func _ready():
	inventory.close()
#
#Custom Functions
#
func _input(event):
	if event.is_action_pressed("inv_toggle"):
		if inventory.is_open:
			inventory.close()
		else:
			inventory.open()
