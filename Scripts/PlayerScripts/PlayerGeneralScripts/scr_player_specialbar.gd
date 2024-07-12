extends TextureProgressBar

@onready var player = $"../.."
@onready var yellow_texture = preload("res://Sprites/GUISprites/PlayerGUI/RadialFills/spr_gui_healthbar_radial_fill_yellow.png")
@onready var violet_texture = preload("res://Sprites/GUISprites/PlayerGUI/RadialFills/spr_gui_healthbar_radial_fill_violet.png")
@onready var sprite: AnimatedSprite2D = $SpecialBarSprite 

var player_num: int = 0

func _ready():
	#value = player.current_special * 100 / player.current_max
	update()

func update():
	player_num = player.form_id
	sprite.frame = player_num
	match player.form_type:
		0:
			set_progress_texture(yellow_texture)
			value = player.yellow_special * 100 / player.current_max
			#current_primary = yellow_primary
		1:
			set_progress_texture(violet_texture)
			value = player.violet_special * 100 / player.current_max
			#current_primary = violet_primary
