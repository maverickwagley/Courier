#scr_gui_player_pause
#
extends CanvasLayer
#
#signal opened
#signal closed
var is_open: bool = false
var player: CharacterBody2D
#
#Built-In Functions
#
func _ready() -> void:
	player = get_parent()
	visible = false
	is_open = false
#
#Custom Functions
#
func toggle_menu() -> void:
	#CM: Player > menu_input()
	if is_open == false:
		open()
	else:
		close()
#
func open() -> void:
	visible = true
	is_open = true
#
func close() -> void:
	visible = false
	is_open = false
	player.form_menu = false
	player.pause_menu = false
#
#Signal Functions
#
func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	close()
#
func _on_home_button_pressed() -> void:
	autoload_game.mode = 0
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/RoomScenes/MetaRooms/rm_home.tscn")
	player.queue_free()
#
func _on_exit_button_pressed() -> void:
	get_tree().quit()
