#Form 1: Adavio
#
extends Form
#
#Built-In Methods
#
func _ready():
	form_id = 1
	is_swap = true
	t_swap = 30
	sprite._set("is_swap",true)
	sprite.apply_intensity_fade(1.0,0.0,0.5)
	player = get_parent()
#
func _physics_process(delta):
	form_swap_process()
	form_special_timer("violet")
	adavio_roll()
	adavio_melee()
	adavio_magic()
	adavio_special()
	adavio_run()
#
#Custom Methods
func adavio_roll():
	form_roll_input()
	if is_roll == true:
		animations.play("anim_adavio_roll_" + last_dir)
		await animations.animation_finished
		player.is_roll = false
		player.is_invincible = false
		is_roll = false
		is_invincible = false
#
func adavio_melee():
	form_melee_input()
	if is_melee == true:
		melee.enable()
		melee.parent_velocity = player.velocity
		animations.play("anim_adavio_hook_" + last_dir)
		await animations.animation_finished
		melee.disable()
		player.is_attack = false
		player.is_melee = false
		is_attack = false
		is_melee = false
#
func adavio_magic():
	form_magic_input()
	var player_velocity = player.velocity
	if is_magic == true:
		magic.player = player
		var cdir = int(magic.get_rotation_degrees()) #magic.get_rotation_degrees()
		magic_dir = autoload_player.cursor_direction(cdir)
		last_dir = autoload_player.cursor_direction(cdir)
		if animations:
			if player_velocity.length() != 0:
				animations.play("anim_adavio_runCast_" + magic_dir)
			else:
				animations.play("anim_adavio_idleCast_" + last_dir)
#
func adavio_special():
	form_special_input()
	if is_special == true:
		special.parent = self
		special.player = player
		var _check = special.special_check()
		player.cursor.adavio_special_cursor(_check)
		if special_start == false:
			print_debug("try special")
			animations.play("anim_adavio_special_cast")
			await animations.animation_finished
			if player.violet_special >= 75:
				special_start = true
				special.is_special = true
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
				if _check == false:
					player.violet_special = player.violet_special - 75
					player.special_gui.update()
					special_use = true
					animations.play("anim_adavio_special_exit")
					if autoload_game.audio_mute == false:
						special.special_snd.play()
					await animations.animation_finished
					player.global_position = player.get_global_mouse_position()
					special.special_use = true
					special.t1 = 60
					special.t2 = 70
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
func adavio_run():
	#CM: _physics_process
	if is_melee == true: return
	if is_roll == true: return
	
	var player_velocity = player.velocity

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
			animations.play("anim_adavio_run_" + direction)
		else:
			animations.play("anim_adavio_idle_" + last_dir)
#
#func play_move_audio(_stepSpeed):
	#if _tMove >= 0:
		#_tMove = _tMove - 1
	#if _tMove < 0:
		#_tMove = _stepSpeed
		#if autoload_game.audio_mute == false:
			#move_audio.play()
#
