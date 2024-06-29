extends TextureProgressBar

@onready var player = $"../.."

func _ready():
	value = player.stamina * 100 / player.max_stamina

func update():
	value = player.stamina * 100 / player.max_stamina
