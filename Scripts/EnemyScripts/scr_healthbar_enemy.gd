extends TextureProgressBar

@onready var enemy = get_parent()

func _ready():
	enemy.sig_health_changed.connect(update)
	update()

func update():
	value = enemy.hp * 100 / enemy.max_hp
