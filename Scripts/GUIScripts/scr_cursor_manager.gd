#Player Cursor Manager
#
extends Node2D
#
@export var home: bool = false
#
@onready var basic_cursor = preload("res://Sprites/GUISprites/PlayerGUI/Cursors/spr_cursor_player.png")
@onready var menu_cursor = preload("res://Sprites/GUISprites/PlayerGUI/Cursors/spr_cursor_menu.png")
@onready var disable_cursor = preload("res://Sprites/GUISprites/PlayerGUI/Cursors/spr_cursor_x.png")
@onready var regaliare_cursor = preload("res://Sprites/GUISprites/PlayerGUI/Cursors/spr_cursor_regaliare.png")
@onready var adavio_cursor = preload("res://Sprites/GUISprites/PlayerGUI/Cursors/spr_cursor_adavio.png")
@onready var cursor_sprite: Sprite2D = $CursorSprite
@onready var form_cursor: Sprite2D = $CursorSprite/FormCursor
@onready var is_disabled: bool = false
@onready var spread: float = 10
@onready var _tDisable: int = 0 #Review With Adavio
@onready var form_id: int = 0
#
#Built-in Methods
#
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	cursor_sprite.texture = basic_cursor
	form_cursor.visible = false
	if home == true:
		cursor_sprite.texture = menu_cursor
#
func _process(delta):
	global_position = get_global_mouse_position()
	if _tDisable > 0:
		_tDisable = _tDisable - 1;
		if _tDisable <= 0:
			cursor_sprite.texture = basic_cursor
#
#Custom Methods
#
func update(_formID: int) -> void:
	match _formID:
		0:
			form_cursor.texture = regaliare_cursor
		1:
			form_cursor.texture = adavio_cursor
#
func adavio_special_cursor(_check: bool) -> void:
	is_disabled = _check
	_tDisable = 3
	
	if is_disabled == true:
		cursor_sprite.texture = disable_cursor
	else:
		if home == true:
			cursor_sprite.texture = menu_cursor
		else:
			cursor_sprite.texture = basic_cursor


