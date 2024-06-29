extends TextureProgressBar

@onready var player = $"../.."

func _ready():
	value = player.primay * 100 / player.max_primary

func update():
	value = player.primary * 100 / player.max_primary
