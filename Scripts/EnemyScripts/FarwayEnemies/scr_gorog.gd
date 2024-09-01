#Enemy Gorog
#
extends Enemy
#
@onready var arrow_scene = preload("res://Scenes/EnemyEntities/ent_projectile_hunter_arrow.tscn")
#
#Built-In Methods
#
func _ready() -> void:
	gorog_ready()
	call_deferred("enemy_nav_setup")
#
func _physics_process(_delta) -> void:
	gorog_slash_state()
	gorog_shield_state()
	gorog_hurt_state()
	gorog_navigation()
	gorog_animation()
#
#Custom Methods
#
func gorog_ready() -> void:
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
	hp = 140
	max_hp = 140
	speed = 45
	knockback_power= 150
	shield = 100
	max_shield = 100
#
func gorog_slash_state() -> void:
	if t_atk1 > 0:
		t_atk1 = t_atk1 - 1
	if is_attack2 == false:
		if t_atk1 <= 0 && attack1_targets.size() > 0:
			is_attack = true
			is_attack1 = true
			attack1.is_attack = true
			is_shielded = false
			t_atk1 = 90
			velocity.x = 0
			velocity.y = 0
			attack1.attack_aud_timer.start()
			animations.play("anim_slash_b_" + last_dir)
			await animations.animation_finished
			if attack1_targets.size() > 0:
				last_dir = enemy_attack_dir(attack1_targets)
				animations.play("anim_slash_f_" + last_dir)
				await animations.animation_finished
				attack1.is_attack = false
				is_attack = false
				is_attack1 = false
			else:
				animations.play("anim_idle_" + last_dir)
				attack1.is_attack = false
				is_attack = false
				is_attack1 = false
#
func gorog_shield_state() -> void:
	if t_atk2 > 0:
		t_atk2 = t_atk2 - 1
	if is_attack1 == false:
		#Shield Up or Down (while walking)
		if is_aggro == true:
			if shield > 0:
				is_shielded = true
				speed = 20
			else:
				is_shielded = false
				speed = 45
		else:
			is_shielded = false
			speed = 45
		#Attack
		#if t_atk2 <= 0 && attack2_targets.size() > 0:
			#print_debug("Attack 2 True")
			#t_atk2 = 480
			#is_attack2 = true
			#last_dir = enemy_attack_dir(attack2_targets)
			#velocity.x = 0
			#velocity.y = 0
			#attack2.attack_timer.start()
			#attack2.attack_aud_timer.start()
			#target_pos = attack2_targets[0].global_position
			#animations.play("anim_shield_bash_" + last_dir)
			#await animations.animation_finished
			#animations.play("anim_idle_" + last_dir)
			##enemy_reposition()
			#attack2.is_attack = false
			##is_attack = false
			#is_attack2 = false
#
func gorog_hurt_state() -> void:
	if is_hurt == true:
		if hurt_areas.size() > 0:
			for i in hurt_areas.size():
				var _damageArea = hurt_areas[i]
				if autoload_enemy.hitbox_area_entered(_damageArea,blood_particle,global_position):
					enemy_apply_damage(_damageArea,4,10)
			if hurt_timer.get_time_left() <= 0:
				var _cryChance = randi_range(0,100)
				if _cryChance >= 50:
					if autoload_game.audio_mute == false:
						hurt_audio.play()
				if autoload_game.audio_mute == false:
					autoload_player.player.damage_dealt_audio.play()
				hurt_timer.start()
#
func gorog_navigation() -> void:
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
	if is_attack2 == true: return
	if nav_agent.is_navigation_finished():
		if is_aggro == true:
			velocity.x = 0
			velocity.y = 0
			return
		else:
			objective_num = objective_num + 1
			if objective_num > 9:
				objective_num = 0
			for spawn in get_tree().get_nodes_in_group("EnemyPathPoint"):
				if spawn.name == str(objective_num):
					nav_agent.target_position  = spawn.global_position
		
	var agent_current_pos = global_position
	var next_path_position = nav_agent.get_next_path_position()
	velocity = agent_current_pos.direction_to(next_path_position) * speed
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
