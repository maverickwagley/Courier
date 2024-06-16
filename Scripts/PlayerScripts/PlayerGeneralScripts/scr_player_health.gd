extends TextureProgressBar

@onready var player = $"../.."

func _ready():
	value = player.hp * 100 / player.max_hp
	#player.sig_health_changed.connect(update)
	#update()

func update():
	value = player.hp * 100 / player.max_hp


