extends Node2D

@onready var current_sprite = preload("res://Sprites/GUISprites/PlayerGUI/spr_cursor_player.png")
@onready var cursor_sprite: Sprite2D = $CursorSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	cursor_sprite.texture = current_sprite


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = get_global_mouse_position()
