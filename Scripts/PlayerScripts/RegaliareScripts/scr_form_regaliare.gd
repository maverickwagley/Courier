extends Node2D

@export var knockback_power = 50

@onready var animations = $AnimationPlayer
@onready var effects = $Effects
@onready var weapon = $MeleeSkill
@onready var magic = $MagicSkill
@onready var special = $SpecialSkill
@onready var hurt_timer = $HurtTimer
@onready var player: CharacterBody2D

var form_id: int = 0
var form_menu: bool = false
var is_invincible: bool = false
var is_hurt: bool = false
var is_knockback: bool = false
var is_roll: bool = false
var is_attack: bool = false
var is_melee: bool = false
var is_magic: bool = false
var is_special: bool = false
var direction = "down"
var last_dir = "down"
var magic_dir = "down"
var melee_dir = "down"
var sync_pos = Vector2(0,0)
var _tSpecial: int = 5
#
#Built-In Methods
#
func _ready():
	effects.play("anim_swap_in")
	player = get_parent()
	pass # Replace with function body.
#
func _physics_process(delta):
	if is_special == false:
		if player.yellow_special < player.current_max:
			if _tSpecial > 0:
				_tSpecial = _tSpecial - 1
			if _tSpecial < 1:
				_tSpecial = 5
				player.yellow_special = player.yellow_special + 1
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
		animations.play("anim_regaliare_roll_" + last_dir)
		await animations.animation_finished
		player.is_roll = false
		player.is_invincible = false
		player.roll_shake = false
		is_roll = false
		is_invincible = false
#
func form_melee():
	if is_melee == true:
		weapon.enable()
		weapon.parent_velocity = player.velocity
		animations.play("anim_regaliare_slash_" + last_dir)
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
		special.is_special = true
		special.player = player
		animations.play("anim_regaliare_special_" + last_dir)
		await animations.animation_finished
		player.is_attack = false
		player.is_special = false
		is_attack = false
		is_special = false
		special.is_special = false
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
		var cdir = int(magic.get_rotation_degrees()) #magic.get_rotation_degrees()
		magic_dir = ScrPlayerGeneral.cursor_direction(cdir)
		last_dir = ScrPlayerGeneral.cursor_direction(cdir)
		if animations:
			if _pVel.length() != 0:
				animations.play("anim_regaliare_runCast_" + magic_dir)
			else:
				animations.play("anim_regaliare_idleCast_" + last_dir)

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
			animations.play("anim_regaliare_walk_" + direction)
		else:
			animations.play("anim_regaliare_idle_" + last_dir)
