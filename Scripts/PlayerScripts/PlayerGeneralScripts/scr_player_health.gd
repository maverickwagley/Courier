extends TextureProgressBar

@onready var player = $"../.."

func _ready():
	value = player.hp * 100 / player.max_hp

func update():
	value = player.hp * 100 / player.max_hp


