#Form 0: Regaliare
#
extends Form
#
#Built-In Methods
#
func _ready() -> void:
	form_id = 0
	form_swap_in()
	player = get_parent()
	melee.player = player
	magic.player = player
	special.player = player
#
func _physics_process(delta) -> void:
	form_swap_process()
	regaliare_roll()
	regaliare_melee()
	regaliare_magic()
	regaliare_special()
	regaliare_base()
	
#
#Custom Methods
func regaliare_roll() -> void:
	#form_roll_input()
	if is_roll == true:
		animations.play("anim_regaliare_roll_" + last_dir)
		await animations.animation_finished
		emit_signal("status_set","is_roll",false)
		emit_signal("status_set","is_invincible",true)
		emit_signal("status_set","roll_shake",false)
		is_roll = false
		is_invincible = false
#
func regaliare_melee() -> void:
	#form_melee_input()
	if is_melee == true:
		melee.enable(player)
		melee.parent_velocity = player.velocity
		animations.play("anim_regaliare_slash_" + last_dir)
		await animations.animation_finished
		melee.disable()
		emit_signal("status_set","is_attack",false)
		emit_signal("status_set","is_melee",false)
		is_attack = false
		is_melee = false
#
func regaliare_magic() -> void:
	#form_magic_input()
	if is_magic == true:
		var cdir = int(magic.get_rotation_degrees()) #magic.get_rotation_degrees()
		magic_dir = form_cursor_direction(cdir)
		last_dir = form_cursor_direction(cdir)
		if animations:
			if player_velocity.length() != 0:
				animations.play("anim_regaliare_runCast_" + magic_dir)
			else:
				animations.play("anim_regaliare_idleCast_" + last_dir)
#
func regaliare_special() -> void:
	if t_special > 0:
		t_special = t_special - 1
	if is_special == true:
		animations.play("anim_regaliare_special_" + last_dir)
		await animations.animation_finished
		if t_special <= 0:
			t_special = 60
			if player.yellow_special >= 100:
				player.yellow_special = player.yellow_special - 100
				is_invincible = true
				special.regaliare_special_projectile_create()
				special.player = player
				player.special_gui.update()
				emit_signal("status_reset")
				emit_signal("status_set","is_attack",false)
				emit_signal("status_set","is_invincible",true)
				emit_signal("status_set","t_invincible",60)
				is_roll = false
				is_attack = false
				is_special = false
		else:
			emit_signal("status_reset")
			is_roll = false
			is_attack = false
			is_special = false
			
		
#
func regaliare_base() -> void:
	#CM: _physics_process
	if is_roll == true: return
	#
	if is_attack == false:
		if player_velocity.length() != 0:
			form_move_audio(18)
			direction = "down"
			last_dir = "down"
			if player_velocity.x < 0: 
				direction = "left"
				last_dir = "left"
			elif player_velocity.x > 0: 
				direction = "right"
				last_dir = "right"
			elif player_velocity.y < 0: 
				direction = "up"
				last_dir = "up"
			animations.play("anim_regaliare_walk_" + direction)
		else:
			animations.play("anim_regaliare_idle_" + last_dir)
#

