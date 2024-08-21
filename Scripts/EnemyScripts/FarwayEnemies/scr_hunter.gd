#Enemy Hunter
#
extends Enemy
#
@onready var arrow_scene = preload("res://Scenes/EnemyEntities/ent_projectile_hunter_arrow.tscn")
#
#Built-In Methods
#
func _ready() -> void:
	hunter_ready()
	call_deferred("enemy_nav_setup")
#
func _physics_process(_delta) -> void:
	hunter_slash_state()
	hunter_bowshot_state()
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
	attack1 = $Attack1Area
	attack1_box = $Attack1Area/Attack1Damagebox
	attack1_timer = $Attack1Area/Attack1Timer
	attack1_detect = $Navigation/Attack1Detect/Attack1DetectCircle
	attack2 = $Attack2Area
	nav_agent = $Navigation/NavigationAgent2D
	hurt_audio = $HurtSFX
	#Set Stats
	hp = 70
	max_hp = 70
	speed = 45
	knockback_power= 150
#
func hunter_slash_state() -> void:
	if t_atk1 > 0:
		t_atk1 = t_atk1 - 1
	if is_attack1 == true:
		velocity.x = 0
		velocity.y = 0
		if t_atk1 <= 0:
			t_atk1 = 90
			attack1.attack_aud_timer.start()
			animations.play("anim_slash_" + last_dir)
			await animations.animation_finished
			animations.play("anim_idle_" + last_dir)
			if attack1_targets.size() < 1:
				attack1.is_attack = false
				is_attack = false
				is_attack1 = false
#
func hunter_bowshot_state() -> void:
	if t_atk2 > 0:
		t_atk2 = t_atk2 - 1
	if is_attack2 == true:
		last_dir = hunter_bowshot_direction()
		velocity.x = 0
		velocity.y = 0
		if t_atk2 <= 0:
			t_atk2 = 90
			attack2.attack_timer.start()
			attack2.attack_aud_timer.start()
			animations.play("anim_bowshot_" + last_dir)
			await animations.animation_finished
			animations.play("anim_idle_" + last_dir)
			if attack2_targets.size() < 1:
				attack2.is_attack = false
				is_attack = false
				is_attack2 = false
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
	if is_attack1 == true: return
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
	if is_attack1 == true: return
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
		
		animations.play("anim_run_" + direction)
	else:
		animations.play("anim_idle_" + last_dir)
#
func hunter_bowshot_direction():
	if attack2_targets.size() >= 1:
		var targetPos = attack2_targets[0].global_position
		targetPos.y = targetPos.y - 8
		var _cdir = rad_to_deg(global_position.angle_to_point(targetPos))
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
	else:
		return last_dir
	#
#
func _on_attack2_timer_timeout():
	if attack2_targets.size() >= 1:
		var projectile = arrow_scene.instantiate()
		var targetPos = attack2_targets[0].global_position
		targetPos.y = targetPos.y - 8
		projectile.global_position = global_position #spawner.global_position
		projectile.global_rotation = get_angle_to(targetPos)
		get_tree().current_scene.add_child(projectile)
