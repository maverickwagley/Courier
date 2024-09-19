#Form Base Class
#
class_name Form
extends Node
#
signal status_set
signal status_reset
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
var is_shielded: bool = false
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
func form_hit() -> void:
	if is_invincible == false:
		if is_shielded == false:
			sprite.apply_intensity_fade(1.0,0.0,0.5)
			sprite._set("is_hurt",true)
		else:
			sprite.apply_intensity_fade(1.0,0.0,0.5)
			sprite._set("is_shielded",true)
	else:
		sprite.apply_intensity_fade(0.5,0.0,0.25)
		sprite._set("is_invincible",true)
	#CM: Player > _on_hitbox_area_entered	#sprite.apply_intensity_fade(1.0,0.0,0.25)
	#sprite._set("is_hurt",true)
	#hurt_timer.start()
	#await hurt_timer.timeout
	#sprite._set("is_hurt",false)
	#emit_signal("status_set","is_hurt",false)
	#emit_signal("status_set","is_knockback",false)
	#is_hurt = false
	#is_knockback = false

#
func form_move_audio(_stepSpeed) -> void:
	if t_move >= 0:
		t_move = t_move - 1
	if t_move < 0:
		t_move = _stepSpeed
		if autoload_game.audio_mute == false:
			move_audio.play()
#
func form_cursor_direction(_cdir):
	#var cdir = rad_to_deg(global_position.angle_to_point(get_global_mouse_position()))
	_cdir = wrapi(_cdir,0,360)
	if _cdir < 0:
		_cdir = 360 - _cdir
	if _cdir < 45:
			return "right"
	if _cdir >= 45:
		if _cdir < 135:
			return "down"
	if _cdir >= 135:
		if _cdir < 225:
			return "left"
	if _cdir >= 225:
		if _cdir < 315:
			return "up"
	if _cdir >= 315:
			return "right"
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
	emit_signal("status_reset")
	is_swap = true
	is_attack = false
	is_special = false
	is_melee = false
	is_magic = false
	is_invincible = false
	special_start = false
	special_use = false
	#special.is_special = false
	t_swap = 30
	sprite._set("is_swap",true)
	sprite.apply_intensity_fade(1.0,0.0,0.5)
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

