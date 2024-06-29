extends TextureProgressBar

@onready var player = $"../.."

func _ready():
	value = player.special * 100 / player.max_special

func update():
	value = player.special * 100 / player.max_special
