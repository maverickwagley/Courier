extends TextureProgressBar

@onready var player = $"../.."
@onready var sprite: AnimatedSprite2D = $HealthBarSprite

var player_num: int = 0

func _ready():
	value = player.hp * 100 / player.max_hp

func update() -> void:
	value = player.hp * 100 / player.max_hp
	player_num = player.form_id
	sprite.frame = player_num


