extends CanvasLayer

signal opened
signal closed
var is_open: bool = false
var player: CharacterBody2D
#
#Built-In Methods
#
func _ready():
	#inventory.updated.connect(update)
	player = get_parent()
	visible = false
	is_open = false
#
func _physics_process(_delta):
	#if is_open == true:
		#if Input.is_action_just_pressed("pause_game"):
			#get_tree().pause = false
	pass
#
#Signal Methods
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
#
#Custom Methods
#
func toggle_menu() -> void:
	if is_open == false:
		open()
	else:
		close()
#
func open() -> void:
	visible = true
	is_open = true
	#opened.emit()
#
func close() -> void:
	visible = false
	is_open = false
	player.form_menu = false
	player.pause_menu = false
	#closed.emit()








