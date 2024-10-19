#scr_gui_home
#
extends Control
#
# Built-In Functions
#
func _ready():
	visible = true
#
#Signal Functions
#
func _on_exit_button_pressed():
	get_tree().quit()
#
func _on_play_button_pressed():
	autoload_game.mode = 1
	get_tree().change_scene_to_file("res://Scenes/RoomScenes/LenkoRooms/rm_farway.tscn")
#
func _on_settings_button_pressed():
	autoload_game.audio_mute = false
