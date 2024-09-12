#Enemy Shield Bar
#
extends TextureProgressBar
#
@onready var enemy = get_parent()
#
#Built-In Methods
#
func _ready():
	value = 0
#
#Custom Methods
#
#func update():
	#if enemy.shield > 0:
		#value = enemy.shield * 100 / enemy.max_shield
