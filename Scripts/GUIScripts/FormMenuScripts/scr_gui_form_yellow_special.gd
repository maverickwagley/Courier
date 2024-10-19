#scr_gui_form_yellow_special
#
extends TextureProgressBar
#
@onready var player = $"../.."
#
var player_num: int = 0
#
#Built-In Functions
#
func _ready():
	value = player.yellow_special * 100 / player.current_max
#
#Custom Functions
#
func update():
	value = player.yellow_special * 100 / player.current_max
