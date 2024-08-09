#Form 0: Regaliare
#
extends Form
#
#Built-In Methods
#
func _ready():
	is_swap = true
	_tSwap = 30
	sprite._set("is_swap",true)
	sprite.apply_intensity_fade(1.0,0.0,0.5)
	player = get_parent()
	melee.player = player
	magic.player = player
	special.player = player
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
	form_run()
	
#
#Custom Methods
func form_roll():
	roll_input()
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
	melee_input()
	if is_melee == true:
		melee.enable(player)
		melee.parent_velocity = player.velocity
		animations.play("anim_regaliare_slash_" + last_dir)
		await animations.animation_finished
		melee.disable()
		player.is_attack = false
		player.is_melee = false
		is_attack = false
		is_melee = false
#
func form_magic():
	magic_input()
	if is_magic == true:
		_pVel = player.velocity
		magic_dir = player.cursor_direction()
		last_dir = player.cursor_direction()
		if animations:
			if _pVel.length() != 0:
				animations.play("anim_regaliare_runCast_" + magic_dir)
			else:
				animations.play("anim_regaliare_idleCast_" + last_dir)
#
func form_special():
	if is_attack == false && is_roll == false:
		if Input.is_action_just_pressed("special_skill"):
			if special_timer.get_time_left() <= 0:
				special_timer.start()
				player.is_attack = true
				player.is_special = true
				is_attack = true
				is_special = true
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
func form_run():
	#CM: _physics_process
	if is_roll == true: return
	
	_pVel = player.velocity
	
	if is_attack == false:
		if _pVel.length() != 0:
			play_move_audio(18)
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
#
func play_move_audio(_stepSpeed):
	if _tMove >= 0:
		_tMove = _tMove - 1
	if _tMove < 0:
		_tMove = _stepSpeed
		if autoload_game.audio_mute == false:
			move_audio.play()
