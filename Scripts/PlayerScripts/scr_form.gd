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
@onready var special_timer: Timer = $SpecialSkill/SpecialTimer
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
#
var direction = "down"
var last_dir = "down"
var magic_dir = "down"
var melee_dir = "down"
var special_dir = "down"
#
var _pVel: Vector2
var _tSpecial: int = 5
var _tMove: int = 0
var _tSwap: int = 15
# 
func roll_input():
	#Offload to form
	#CM: handle_input
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
func melee_input():
	#Offload to Form
	#CM: handle_input
	if is_roll == true: return
	if is_attack == false:
		if Input.is_action_just_pressed("melee_skill"):
			player.is_attack = true
			player.is_melee = true
			is_attack = true
			is_melee = true
			#if melee_aim = true
			#var cdir = rad_to_deg(global_position.angle_to_point(get_global_mouse_position()))
			melee_dir = player.cursor_direction()
			last_dir = player.cursor_direction()
#
func magic_input():
	#Offload to Form
	#CM: handle_input
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
