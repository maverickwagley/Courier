extends Node2D

@export var home: bool = false

@onready var current_sprite = preload("res://Sprites/GUISprites/PlayerGUI/Cursors/spr_cursor_player.png")
@onready var menu_cursor = preload("res://Sprites/GUISprites/PlayerGUI/Cursors/spr_cursor_menu.png")
@onready var regaliare_cursor = preload("res://Sprites/GUISprites/PlayerGUI/Cursors/spr_cursor_regaliare.png")
@onready var adavio_cursor = preload("res://Sprites/GUISprites/PlayerGUI/Cursors/spr_cursor_adavio.png")
@onready var cursor_sprite: Sprite2D = $CursorSprite
@onready var form_cursor: Sprite2D = $CursorSprite/FormCursor

@onready var spread: float = 10
@onready var _tSpread: int = 0
@onready var form_id: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	cursor_sprite.texture = current_sprite
	if home == true:
		cursor_sprite.texture = menu_cursor


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = get_global_mouse_position()
	
#
#Custom Methods
func update(_formID: int):
	match _formID:
		0:
			form_cursor.texture = regaliare_cursor
		1:
			form_cursor.texture = adavio_cursor
	

