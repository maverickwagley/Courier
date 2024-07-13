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
func _on_unpause_button_pressed():
	get_tree().paused = false
	close()
#
#Custom Methods
#
func toggle_menu():
	if is_open == false:
		open()
	else:
		close()
#
func open():
	visible = true
	is_open = true
	#opened.emit()
#
func close():
	visible = false
	is_open = false
	player.form_menu = false
	player.pause_menu = false
	#closed.emit()

