extends Node2D

@export var knockback_power = 50

@onready var sprite: Sprite2D = $CharacterSprite
@onready var animations: AnimationPlayer = $AnimationPlayer
@onready var weapon: Node2D = $MeleeSkill
@onready var magic: Node2D = $MagicSkill
@onready var special: Node2D = $SpecialSkill
@onready var hurt_timer: Timer = $HurtTimer
@onready var move_audio: AudioStreamPlayer = $MovementSFX
@onready var player: CharacterBody2D = get_parent()

var form_id: int = 1
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
var direction = "down"
var last_dir = "down"
var magic_dir = "down"
var melee_dir = "down"
var sync_pos = Vector2(0,0)
var _tSpecial: int = 0
var _tMove: int = 0
var _tSwap: int = 15
#
#Built-In Methods
#
func _ready():
	is_swap = true
	_tSwap = 30
	sprite._set("is_swap",true)
	sprite.apply_intensity_fade(1.0,0.0,0.5)
	player = get_parent()
#
func _physics_process(delta):
	if is_swap == true:
		if _tSwap > 0:
			_tSwap = _tSwap - 1
		else:
			is_swap = false
			sprite._set("is_swap",false)
			_tSwap = 30
	if is_special == false:
		if player.violet_special < player.current_max:
			if _tSpecial > 0:
				_tSpecial = _tSpecial - 1
			if _tSpecial < 1:
				_tSpecial = 5
				player.violet_special = player.violet_special + 1
				player.special_gui.update()
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
	if is_magic == true:
		magic.player = player
#
func form_special():
	if is_special == true:
		if special_start == false:
			
			animations.play("anim_adavio_special_cast")
			await animations.animation_finished
			if player.violet_special >= 75:
				special_start = true
				special.is_special = true
				special.parent = self
				special.player = player
			else:
				is_attack = false
				is_special = false
				special_start = false
				special_use = false
				special.is_special = false
				special.special_use = false
				special.special_collision.disable()
				player.is_attack = false
				player.is_special = false
			
		if Input.is_action_just_pressed("magic_skill"):
			if special_use == false:
				var _check = special.special_check()
				if _check == false:
					player.violet_special = player.violet_special - 75
					player.special_gui.update()
					special_use = true
					animations.play("anim_adavio_special_exit")
					await animations.animation_finished
					player.global_position = get_global_mouse_position()
					special.special_use = true
					special.t1 = 60
					special.t2 = 90
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
func update_animation():
	#CM: _physics_process
	if is_melee == true: return
	if is_roll == true: return
	
	var _pVel = player.velocity
	
	if is_magic == true:
		var cdir = int(magic.get_rotation_degrees()) #magic.get_rotation_degrees()
		magic_dir = ScrPlayerGeneral.cursor_direction(cdir)
		last_dir = ScrPlayerGeneral.cursor_direction(cdir)
		if animations:
			if _pVel.length() != 0:
				animations.play("anim_adavio_runCast_" + magic_dir)
			else:
				animations.play("anim_adavio_idleCast_" + last_dir)

	if is_attack == false:
		if _pVel.length() != 0:
			play_move_audio(36)
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
func play_move_audio(_stepSpeed):
	if _tMove >= 0:
		_tMove = _tMove - 1
	if _tMove < 0:
		_tMove = _stepSpeed
		if ScrGameManager.audio_mute == false:
			move_audio.play()
#
func _on_melee_area_entered(area):
	#print_debug(area)
	pass # Replace with function body.
