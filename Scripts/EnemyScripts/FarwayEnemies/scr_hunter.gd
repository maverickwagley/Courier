#Enemy Hunter
#
extends Enemy
#
#Built-In Methods
#
func _ready() -> void:
	hunter_ready()
	call_deferred("enemy_nav_setup")
#
func _physics_process(_delta) -> void:
	hunter_melee_state()
	hunter_hurt_state()
	hunter_navigation()
	hunter_animation()
#
#Custom Methods
#
func hunter_ready() -> void:
	#Set Child Nodes
	sprite = $EnemySprite
	animations = $AnimationPlayer
	effects = $Effects
	health = $HealthBar
	hurt_timer = $HurtTimer
	hurt_box = $HitArea/Hitbox
	melee = $MeleeWeapon
	melee_box = $MeleeWeapon/Damagebox
	melee_timer = $MeleeWeapon/MeleeTimer
	melee_detect = $Navigation/MeleeDetect/MeleeDetectCircle
	nav_agent = $Navigation/NavigationAgent2D
	hurt_audio = $HurtSFX
	#Set Stats
	hp = 70
	max_hp = 70
	speed = 45
	knockback_power= 150
#
func hunter_melee_state() -> void:
	if t_melee > 0:
		t_melee = t_melee - 1
	if is_melee == true:
		velocity.x = 0
		velocity.y = 0
		if t_melee <= 0:
			t_melee = 90
			melee.melee_aud_timer.start()
			animations.play("anim_skirmisher_slash_" + last_dir)
			await animations.animation_finished
			animations.play("anim_skirmisher_idle_" + last_dir)
			if melee_targets.size() < 1:
				melee.is_melee = false
				is_attack = false
				is_melee = false
#
func hunter_hurt_state() -> void:
	if is_hurt == true:
		if hurt_areas.size() > 0:
			for i in hurt_areas.size():
				var _damageArea = hurt_areas[i]
				if autoload_enemy.hitbox_area_entered(_damageArea,blood_particle,global_position):
					enemy_apply_damage(_damageArea)
			if hurt_timer.get_time_left() <= 0:
				var _cryChance = randi_range(0,100)
				if _cryChance >= 50:
					if autoload_game.audio_mute == false:
						hurt_audio.play()
				if autoload_game.audio_mute == false:
					autoload_player.player.damage_dealt_audio.play()
				hurt_timer.start()
#
func hunter_navigation() -> void:
	move_and_slide()
	enemy_aggro_drop()
	#
	if is_knockback == true:
		t_knockback = t_knockback - 1
		if t_knockback < 1:
			velocity.x = 0
			velocity.y = 0
			is_knockback = false
		return
	if is_melee == true: return
	if nav_agent.is_navigation_finished():
		if is_aggro == true:
			velocity.x = 0
			velocity.y = 0
			return
		else:
			for spawn in get_tree().get_nodes_in_group("EnemyPathPoint"):
				if spawn.name == str(objective_num + 1):
					nav_agent.target_position  = spawn.global_position
			objective_num = objective_num + 1
		
	var agent_current_pos = global_position
	var next_path_position = nav_agent.get_next_path_position()
	velocity = agent_current_pos.direction_to(next_path_position) * speed
#
func hunter_animation() -> void:
	if is_melee == true: return
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
		
		animations.play("anim_skirmisher_run_" + direction)
	else:
		animations.play("anim_skirmisher_idle_" + last_dir)







