#Form Base Class
#
class_name Form
extends Node
#
@export var knockback_power = 50
#
@onready var sprite: Sprite2D = $CharacterSprite
@onready var animations: AnimationPlayer = $AnimationPlayer
@onready var melee: Node2D = $MeleeSkill
@onready var magic: Node2D = $MagicSkill
@onready var special: Node2D = $SpecialSkill
@onready var hurt_timer: Timer = $HurtTimer
@onready var move_audio: AudioStreamPlayer = $MovementSFX
@onready var player: CharacterBody2D
#
var form_id: int = 0
var form_menu: bool = false
var is_invincible: bool = false
var is_swap: bool = false
var is_hurt: bool = false
var is_knockback: bool = false
var is_roll: bool = false
var is_attack: bool = false
var is_melee: bool = false
var is_magic: bool = false
var is_special: bool = false
var special_start: bool = false
var special_use: bool = false
#
var direction = "down"
var last_dir = "down"
var magic_dir = "down"
var melee_dir = "down"
var special_dir = "down"
#
var player_velocity: Vector2
var t_special: int = 5
var t_move: int = 0
var t_swap: int = 15
# 
#Custom Methods
#
func form_roll_input() -> void:
	#CM: form_roll
	if is_attack == false && is_swap == false:
		if is_roll == false:
			if Input.is_action_just_pressed("roll"):
				if player.stamina >= 50:
					player.stamina = player.stamina - 50
					player.velocity = player.velocity * 2
					player.is_roll = true
					player.is_invincible = true
					is_roll = true
					is_invincible = true
					player.stamina_gui.update()
#
func form_melee_input() -> void:
	#CM: form_melee
	if is_roll == true: return
	if is_attack == false:
		if Input.is_action_just_pressed("melee_skill"):
			player.is_attack = true
			player.is_melee = true
			is_attack = true
			is_melee = true
			melee_dir = player.cursor_direction()
			last_dir = player.cursor_direction()
#
func form_magic_input() -> void:
	#CM: form_magic
	if is_attack == false && is_roll == false:
		if Input.is_action_pressed("magic_skill"):
			is_attack = true
			is_magic = true
			player.cursor.form_cursor.visible = true
			is_attack = true
			is_magic = true
			player.speed = 40
			magic.update()
	if is_magic == true:
		if Input.is_action_just_released("magic_skill"):
			is_attack = false
			is_magic = false
			player.cursor.form_cursor.visible = false
			is_attack = false
			is_magic = false
			player.speed = 60
			magic.update()
#
func form_special_input() -> void:
	#CM: form_special
	if is_attack == false && is_roll == false:
		if Input.is_action_just_pressed("special_skill"):
			player.is_attack = true
			player.is_special = true
			is_attack = true
			is_special = true
#
func form_hit() -> void:
	sprite.apply_intensity_fade(1.0,0.0,0.25)
	sprite._set("is_hurt",true)
	hurt_timer.start()
	await hurt_timer.timeout
	sprite._set("is_hurt",false)
	player.is_hurt = false
	player.is_knockback = false
	is_hurt = false
	is_knockback = false
#
func form_status_reset() -> void:
	is_invincible = false
	is_swap = false
	is_hurt = false
	is_knockback = false
	is_roll = false
	is_attack = false
	is_melee = false
	is_magic = false
	is_special = false
#
func form_move_audio(_stepSpeed) -> void:
	if t_move >= 0:
		t_move = t_move - 1
	if t_move < 0:
		t_move = _stepSpeed
		if autoload_game.audio_mute == false:
			move_audio.play()
#
func form_swap_process() -> void:
	if is_swap == true:
		if t_swap > 0:
			t_swap = t_swap - 1
		else:
			is_swap = false
			sprite._set("is_swap",false)
			t_swap = 30
#
func form_swap_in() -> void:
	is_swap = true
	t_swap = 30
	sprite._set("is_swap",true)
	sprite.apply_intensity_fade(1.0,0.0,0.5)
#
func form_special_timer(_type) -> void:
	if is_special == false:
		match _type:
			"yellow":
				if player.yellow_special < player.current_max:
					if t_special > 0:
						t_special = t_special - 1
					if t_special < 1:
						t_special = 5
						player.yellow_special = player.yellow_special + 1
						player.special_gui.update()
				return
			"violet":
				if player.violet_special < player.current_max:
					if t_special > 0:
						t_special = t_special - 1
					if t_special < 1:
						t_special = 5
						player.violet_special = player.violet_special + 1
						player.special_gui.update()
				return
#
