extends TextureProgressBar

@onready var player = $"../.."
@onready var sprite: AnimatedSprite2D = $StaminaBarSprite 

var player_num: int = 0

func _ready():
	value = player.stamina * 100 / player.max_stamina

func update():
	value = player.stamina * 100 / player.max_stamina
	player_num = player.form_id
	sprite.frame = player_num
