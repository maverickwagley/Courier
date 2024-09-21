#Player HUD
#
extends CanvasLayer
#
@onready var healthbar: TextureProgressBar = $HealthBar
@onready var staminabar: TextureProgressBar = $StaminaBar
@onready var primarybar: TextureProgressBar = $PrimaryBar
@onready var specialbar: TextureProgressBar = $SpecialBar
#
@onready var heath_texture = preload("res://Sprites/GUISprites/PlayerGUI/RadialFills/spr_gui_healthbar_radial_fill_health.png")
@onready var stamina_texture = preload("res://Sprites/GUISprites/PlayerGUI/RadialFills/spr_gui_healthbar_radial_fill_stamina.png")
#
#Built-in Methods
#
func _ready() -> void:
	visible = true
#
#Custom Methods
#
func gui_update_all() -> void:
	healthbar.update()
	staminabar.update()
	primarybar.update()
	specialbar.update()
