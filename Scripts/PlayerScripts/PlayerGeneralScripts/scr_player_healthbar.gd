#scr_player_healthbar
#
extends TextureProgressBar
#
@onready var player = $"../.."
@onready var sprite: AnimatedSprite2D = $HealthBarSprite
#
var player_num: int = 0
#
#Built-in Functions
#
func _ready() -> void:
	value = player.hp * 100 / player.max_hp
#
#Custom Functions
#
func update() -> void:
	#CM: Player > apply_damage()
	if player.hp > player.max_hp:
		player.hp = player.max_hp
	value = player.hp * 100 / player.max_hp
	player_num = player.form_id
	sprite.frame = player_num
