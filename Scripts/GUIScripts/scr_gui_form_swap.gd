extends CanvasLayer

signal opened
signal closed
var is_open: bool = false
var player_form: int = 0
var player: CharacterBody2D
var form_array: Array
var form0: int = 0
var form1: int = 1
var form2: int = 2
var form3: int = 3
var form4: int = 4
var form5: int = 5
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
	pass
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
	#closed.emit()

func _on_form_button_down():
	if player_form == 0:
		return
	else:
		player.form_update(0)
		player_form = 0
#
func _on_form_button_2_down():
	if player_form == 1:
		return
	else:
		player.form_update(1)
		player_form = 1
