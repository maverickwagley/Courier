extends TextureProgressBar

@onready var player = $"../.."

func _ready():
	#value = player.current_special * 100 / player.current_max
	update()

func update():
	match player.form_type:
		0:
			#set_progress_texture(yellow_texture)
			value = player.yellow_primary * 100 / player.current_max
			#current_primary = yellow_primary
		1:
			#set_progress_texture(violet_texture)
			value = player.yellow_primary * 100 / player.current_max
			#current_primary = violet_primary
