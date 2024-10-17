#Enemy Gorog
#
extends Enemy
#
#@onready var arrow_scene = preload("res://Scenes/EnemyEntities/ent_projectile_hunter_arrow.tscn")
#@onready var shieldBash_smear = $Attack2Area/Attack2Sprite
#
#Built-In Methods
#
func _ready() -> void:
	gorog_ready()
	call_deferred("enemy_nav_calc")
#
func _physics_process(delta) -> void:
	#Generic Status
	enemy_timers(delta)
	enemy_hurt()
	#Custom Attacks
	gorog_slash_state()
	gorog_shield_state()
	#Generic Naviation
	enemy_navigation(delta)
	#Custom Animation
	gorog_animation()
#
#Custom Methods
#
func gorog_ready() -> void:
	#Set Child Nodes
	sprite = $EnemySprite
	animations = $AnimationPlayer
	#effects = $Effects
	healthbar = $HealthBar
	shieldbar = $ShieldBar
	hurt_box = $HitArea/Hitbox
	attack1 = $Attack1Area
	attack1_box = $Attack1Area/Attack1Damagebox
	attack1_detect = $Navigation/Attack1Detect/Attack1DetectCircle
	attack2 = $Attack2Area
	attack2_box = $Attack2Area/Attack2Damagebox
	nav_agent = $Navigation/NavigationAgent2D
	hurt_audio = $HurtSFX
	shielded_audio = $ShieldedSFX
	#Set Stats
	hp = 140
	max_hp = 140
	speed = 45
	knockback_power= 150
	shield = 100
	max_shield = 100
	
	#is_stopped = false
#
func gorog_slash_state() -> void:
	if is_attack2 == true: return
	if is_attack1 == true && t_atk1D <= 0:
		is_shielded = false
		shieldbar.visible = false
		t_atk1D = t_atk1C
		attack1.targets_hit.clear()
		attack1.damagebox.disabled = false
	if t_atk1C <= 0 && attack1_targets.size() > 0:
		is_shielded = false
		shieldbar.visible = false
		attack1.is_attack = true
		is_attack1 = true
		is_attack = true
		is_stopped = true
		t_atk1C = 90
		t_atk1D = 12
		velocity.x = 0
		velocity.y = 0
		attack1.attack_aud_timer.start()
		last_dir = enemy_attack_dir(attack1_targets)
		animations.play("anim_slash_b_" + last_dir)
		await animations.animation_finished
		if attack1_targets.size() > 0:
			t_atk1C = 90
			attack1.targets_hit.clear()
			last_dir = enemy_attack_dir(attack1_targets)
			animations.play("anim_slash_f_" + last_dir)
			await animations.animation_finished
			animations.play("anim_idle_" + last_dir)
			last_dir = enemy_attack_dir(attack1_targets)
			enemy_nav_calc()
			is_stopped = false
			attack1.is_attack = false
			attack1.damagebox.disabled = true
			is_attack = false
			is_attack1 = false
		else:
			animations.play("anim_idle_" + last_dir)
			last_dir = enemy_attack_dir(attack1_targets)
			enemy_nav_calc()
			is_stopped = false
			attack1.is_attack = false
			attack1.damagebox.disabled = true
			is_attack = false
			is_attack1 = false
#
func gorog_shield_state() -> void:
	if is_attack1 == true: 
		is_shielded = false
		shieldbar.visible = false
		return
	if is_shielded == false:
		shieldbar.visible = false
		if shield < max_shield:
			if t_shield > 0:
				t_shield = t_shield - 1
		if t_shield <= 0:
			t_shield = 3
			shieldbar.value = shield * 100 / max_shield
			shield = shield + 1
	#Shield Up or Down (while walking)
	if is_attack2 == false:
		if shield_targets.size() > 0:
			if shield > 49:
				shieldbar.visible = true
				is_shielded = true
				speed = 20
			if shield <= 0:
				shieldbar.visible = false
				is_shielded = false
				speed = 45
		else:
			shieldbar.visible = false
			is_shielded = false
			speed = 45
	#Dash Forward
	if is_attack2 == true:
		if attack2.targets_hit.size() > 0:
			velocity.x = 0
			velocity.y = 0
		move_and_slide()
	#Initiate if shield isn't recharging
	if is_shielded == true:
		#initiate Attack
		shieldbar.value = shield * 100 / max_shield
		if t_atk2C <= 0 && attack2_targets.size() > 0:
			t_atk2C = 480
			is_stopped = true
			is_attack = true
			is_attack2 = true
			attack2_box.disabled = false
			target_pos = attack2_targets[0].global_position
			var axis = to_local(nav_agent.get_next_path_position()).normalized()
			velocity = axis * 110
			last_dir = enemy_attack_dir(attack2_targets)
			#speed = 110
			#attack2.attack_timer.start()
			if autoload_game.audio_mute == false:
				attack2.attack_audio.play()
			animations.play("anim_shield_bash_" + last_dir)
			await animations.animation_finished
			animations.play("anim_idle_" + last_dir)
			enemy_nav_calc()
			attack2_box.disabled = true
			attack2.targets_hit.clear()
			attack2.is_attack = false
			is_shielded = true
			shield = shield + 50
			if shield > max_shield:
				shield = max_shield
			is_stopped = false
			is_attack = false
			is_attack2 = false
#
func gorog_animation() -> void:
	if is_attack1 == true: return
	if is_attack2 == true: return
	if is_knockback == true: return
		
	if velocity.length() != 0:
		move_dir = velocity.normalized()
		direction = "down"
		last_dir = "down"
		if round(move_dir.x) < 0: 
			direction = "left"
			last_dir = "left"
		if round(move_dir.x) > 0: 
			direction = "right"
			last_dir = "right"
		if round(move_dir.y) < 0: 
			direction = "up"
			last_dir = "up"
		if round(move_dir.y) > 0: 
			direction = "down"
			last_dir = "down"
		if is_shielded == true:
			animations.play("anim_shield_move_" + direction)
		else:
			animations.play("anim_run_" + direction)
	else:
		animations.play("anim_idle_" + last_dir)
#
