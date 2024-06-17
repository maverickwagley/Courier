extends Node2D

@export var knockback_power = 50

@onready var animations = $AnimationPlayer
@onready var effects = $Effects
@onready var weapon = $MeleeSkill
@onready var magic = $MagicSkill
@onready var special = $SpecialSkill
@onready var hurt_timer = $HurtTimer
@onready var player: CharacterBody2D = get_parent()

var form_id: int = 1
var form_menu: bool = false
var is_invincible: bool = false
var is_hurt: bool = false
var is_knockback: bool = false
var is_roll: bool = false
var is_attack: bool = false
var is_melee: bool = false
var is_magic: bool = false
var is_special: bool = false
var special_start: bool = false
var special_use: bool = false
var direction = "down"
var last_dir = "down"
var magic_dir = "down"
var sync_pos = Vector2(0,0)
#
#Built-In Methods
#
func _ready():
	effects.play("anim_swap_in")
	pass # Replace with function body.
#
func _physics_process(delta):
	form_roll()
	form_melee()
	form_magic()
	form_special()
	update_animation()
#
#Custom Methods
func form_roll():
	if is_roll == true:
		animations.play("anim_adavio_roll_" + last_dir)
		await animations.animation_finished
		player.is_roll = false
		player.is_invincible = false
		is_roll = false
		is_invincible = false
#
func form_melee():
	if is_melee == true:
		weapon.enable()
		weapon.parent_velocity = player.velocity
		animations.play("anim_adavio_hook_" + last_dir)
		await animations.animation_finished
		weapon.disable()
		player.is_attack = false
		player.is_melee = false
		is_attack = false
		is_melee = false
#
func form_magic():
	pass
#
func form_special():
	if is_special == true:
		if special_start == false:
			
			animations.play("anim_adavio_special_cast")
			await animations.animation_finished
			special_start = true
			special.is_special = true
			special.parent = self
			special.player = player
			
		if Input.is_action_just_pressed("magic_skill"):
			if special_use == false:
				var _check = special.special_check()
				if _check == false:
					special_use = true
					animations.play("anim_adavio_special_exit")
					await animations.animation_finished
					player.global_position = get_global_mouse_position()
					special.special_use = true
					special.t1 = 60
					special.t2 = 75
					animations.play("anim_adavio_special_enter")
					await animations.animation_finished
					player.is_attack = false
					player.is_special = false
					is_attack = false
					is_special = false
					special_start = false
					special_use = false
					special.is_special = false
					special.special_use = false
					special.special_collision.disable()
#
func form_hit():
	effects.play("anim_hurt_blink")
	hurt_timer.start()
	await hurt_timer.timeout
	effects.play("RESET")
	player.is_hurt = false
	player.is_knockback = false
	is_hurt = false
	is_knockback = false
#
func update_animation():
	#CM: _physics_process
	if is_melee == true: return
	if is_roll == true: return
	
	var _pVel = player.velocity
	
	if is_magic == true:
		var mdir = int(magic.get_rotation_degrees()) #magic.get_rotation_degrees()
		magic_dir = ScrPlayerGeneral.magic_direction(mdir)
		last_dir = ScrPlayerGeneral.magic_direction(mdir)
		if animations:
			if _pVel.length() != 0:
				animations.play("anim_adavio_runCast_" + magic_dir)
			else:
				animations.play("anim_adavio_idleCast_" + last_dir)

	if is_attack == false:
		if _pVel.length() != 0:
			direction = "down"
			last_dir = "down"
			if _pVel.x < 0: 
				direction = "left"
				last_dir = "left"
			elif _pVel.x > 0: 
				direction = "right"
				last_dir = "right"
			elif _pVel.y < 0: 
				direction = "up"
				last_dir = "up"
			animations.play("anim_adavio_run_" + direction)
		else:
			animations.play("anim_adavio_idle_" + last_dir)
#
func _on_melee_area_entered(area):
	print_debug(area)
	pass # Replace with function body.
