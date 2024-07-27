extends Node2D

@onready var current_sprite = preload("res://Sprites/GUISprites/PlayerGUI/Cursors/spr_cursor_player.png")
@onready var cursor_sprite: Sprite2D = $CursorSprite
@onready var form_cursor: NinePatchRect = $FormCursor

@onready var spread: float = 1.0
@onready var _tFloat: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	cursor_sprite.texture = current_sprite


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = get_global_mouse_position()
	
#
#Custom Methods
#
func apply_spread(_spread: int) -> void:
	var _newSpread = Vector2(_spread,_spread)
	var _newOffset = Vector2(-(int(_spread/2)),-(int(_spread/2)))
	form_cursor.set_size(_newSpread,false)
	form_cursor.set_position(_newOffset)
