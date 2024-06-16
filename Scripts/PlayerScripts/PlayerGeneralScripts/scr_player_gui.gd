extends CanvasLayer

@onready var healthbar = $HealthBar

func _ready():
	visible = true
	pass
	#inventory.close()

func _input(event):
	pass
	#if event.is_action_pressed("inv_toggle"):
		#if inventory.is_open:
			#inventory.close()
		#else:
			#inventory.open()
