extends CanvasLayer

@onready var inventory = $InventoryGUI 

func _ready():
	inventory.close()

func _input(event):
	if event.is_action_pressed("inv_toggle"):
		if inventory.is_open:
			inventory.close()
		else:
			inventory.open()
