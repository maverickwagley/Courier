extends CanvasLayer

@onready var healthbar: TextureProgressBar = $HealthBar
@onready var staminabar: TextureProgressBar = $StaminaBar
@onready var primarybar: TextureProgressBar = $PrimaryBar
@onready var specialbar: TextureProgressBar = $SpecialBar

@onready var heath_texture = preload("res://Sprites/GUISprites/PlayerGUI/RadialFills/spr_gui_healthbar_radial_fill_health.png")
@onready var stamina_texture = preload("res://Sprites/GUISprites/PlayerGUI/RadialFills/spr_gui_healthbar_radial_fill_stamina.png")


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
