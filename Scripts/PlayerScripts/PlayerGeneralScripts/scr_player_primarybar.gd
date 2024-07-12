extends TextureProgressBar

@onready var player = $"../.."
@onready var yellow_texture = preload("res://Sprites/GUISprites/PlayerGUI/RadialFills/spr_gui_healthbar_radial_fill_yellow.png")
@onready var violet_texture = preload("res://Sprites/GUISprites/PlayerGUI/RadialFills/spr_gui_healthbar_radial_fill_violet.png")
@onready var sprite: AnimatedSprite2D = $PrimaryBarSprite

var player_num: int = 0
#@onready var green_texture = preload()
#@onready var blue_texture = preload()
#@onready var orange_texture = preload()
#@onready var red_texture = preload()

func _ready():
	update()
	#value = player.current_primary * 100 / player.current_max

func update():
	#value = player.current_primary * 100 / player.current_max
	player_num = player.form_id
	sprite.frame = player_num
	
	if player.yellow_primary > player.current_max:
		player.yellow_primary = player.current_max
	if player.violet_primary > player.current_max:
		player.violet_primary = player.current_max
	match player.form_type:
		0:
			set_progress_texture(yellow_texture)
			value = player.yellow_primary * 100 / player.current_max
			#current_primary = yellow_primary
		1:
			set_progress_texture(violet_texture)
			value = player.violet_primary * 100 / player.current_max
			#current_primary = violet_primary
