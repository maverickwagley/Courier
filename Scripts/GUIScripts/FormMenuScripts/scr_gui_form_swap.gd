extends CanvasLayer

signal opened
signal closed

@onready var health_bar: TextureProgressBar = $Control/HealthBar
@onready var stamina_bar: TextureProgressBar = $Control/StaminaBar
@onready var current_form: AnimatedSprite2D = $Control/CurrentFormSprite

@onready var yellow_button: TextureButton = $Control/YellowFormButton
@onready var yellow_sprite: AnimatedSprite2D = $Control/YellowFormButton/YellowFormSprite
@onready var yellow_primary: TextureProgressBar = $Control/YellowFormButton/YellowPrimaryBar
@onready var yellow_special: TextureProgressBar = $Control/YellowFormButton/YellowSpecialBar

@onready var violet_button: TextureButton = $Control/VioletFormButton
@onready var violet_sprite: AnimatedSprite2D = $Control/VioletFormButton/VioletFormSprite
@onready var violet_primary: TextureProgressBar = $Control/VioletFormButton/VioletPrimaryBar
@onready var violet_special: TextureProgressBar = $Control/VioletFormButton/VioletSpecialBar

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
	current_form.set_frame_and_progress(player.form_id,0.0)
	health_bar.set_value(player.hp * 100 / player.max_hp)
	stamina_bar.set_value(player.stamina * 100 / player.max_stamina)
	yellow_special.set_value(player.yellow_special * 100 / player.current_max)
	yellow_primary.set_value(player.yellow_primary * 100 / player.current_max)
	violet_primary.set_value(player.violet_primary * 100 / player.current_max)
	violet_special.set_value(player.violet_special * 100 / player.current_max)








