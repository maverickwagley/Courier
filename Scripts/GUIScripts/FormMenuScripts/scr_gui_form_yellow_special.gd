extends TextureProgressBar

@onready var player = $"../.."

var player_num: int = 0

func _ready():
	value = player.yellow_special * 100 / player.current_max

func update():
	value = player.yellow_special * 100 / player.current_max
