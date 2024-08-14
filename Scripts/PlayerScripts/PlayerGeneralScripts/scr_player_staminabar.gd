#Player Stamina Bar
#
extends TextureProgressBar
#
@onready var player = $"../.."
@onready var sprite: AnimatedSprite2D = $StaminaBarSprite 
#
var player_num: int = 0
#
#Built-in Methods
#
func _ready() -> void:
	value = player.stamina * 100 / player.max_stamina
#
#Custom Methods
#
func update() -> void:
	#CM: Player > roll_input()
	value = player.stamina * 100 / player.max_stamina
	player_num = player.form_id
	sprite.frame = player_num
