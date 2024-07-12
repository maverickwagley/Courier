extends CanvasLayer

signal opened
signal closed

@onready var yellow_button: TextureButton = $Control/YellowFormButton
@onready var yellow_sprite: AnimatedSprite2D = $Control/YellowFormButton/YellowFormSprite
@onready var yellow_primary: TextureProgressBar = $Control/YellowFormButton/YellowPrimaryBar
@onready var yellow_special: TextureProgressBar = $Control/YellowFormButton/YellowSpecialBar

@onready var violet_button: TextureButton = $Control/VioletFormButton
@onready var violet_sprite: AnimatedSprite2D = $Control/YellowFormButton/YellowFormSprite
@onready var violet_primary: TextureProgressBar = $Control/YellowFormButton/YellowPrimaryBar
@onready var violet_special: TextureProgressBar = $Control/YellowFormButton/YellowSpecialBar



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
#Signal Methods
#
func _on_yellow_form_button_pressed():
	if player_form == 0:
		player.form_menu = false
		get_tree().paused = false
		close()
	else:
		player.form_update(0,0)
		player_form = 0
		player.form_menu = false
		get_tree().paused = false
		close()
#
func _on_violet_form_button_pressed():
	if player_form == 1:
		player.form_menu = false
		get_tree().paused = false
		close()
	else:
		player.form_update(1,1)
		player_form = 1
		player.form_menu = false
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
	
	update()
	visible = true
	is_open = true
	#opened.emit()
#
func close():
	visible = false
	is_open = false
	#closed.emit()
#
func update():
	#yellow_primary.value = player.yellow_primary * 100 / player.current_max
	yellow_special.set_value(player.yellow_special * 100 / player.current_max)
	yellow_primary.set_value(player.yellow_primary * 100 / player.current_max)
	print_debug(yellow_primary.value)
	print_debug(yellow_special.value)
	violet_primary.value = player.violet_primary * 100 / player.current_max
	violet_special.value = player.violet_special * 100 / player.current_max
	print_debug("Form Menu Update")







