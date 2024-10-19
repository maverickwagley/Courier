#scr_player_staminabar
#
extends TextureProgressBar
#
@onready var player = $"../.."
@onready var sprite: AnimatedSprite2D = $StaminaBarSprite 
#
var player_num: int = 0
#
#Built-in Functions
#
func _ready() -> void:
	value = player.stamina * 100 / player.max_stamina
#
#Custom Functions
#
func update() -> void:
	#CM: Player > roll_input()
	value = player.stamina * 100 / player.max_stamina
	player_num = player.form_id
	sprite.frame = player_num
