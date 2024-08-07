#Player Health Bar
#
extends TextureProgressBar
#
@onready var player = $"../.."
@onready var sprite: AnimatedSprite2D = $HealthBarSprite
#
var player_num: int = 0
#
#Built-in Methods
#
func _ready():
	value = player.hp * 100 / player.max_hp
#
#Custom Methods
#
func update() -> void:
	#CM: Player > apply_damage()
	value = player.hp * 100 / player.max_hp
	player_num = player.form_id
	sprite.frame = player_num


