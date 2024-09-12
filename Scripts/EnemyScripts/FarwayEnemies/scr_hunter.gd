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
	call_deferred("enemy_nav_calc")
#
func _physics_process(delta) -> void:
	#Generic Status
	enemy_timers(delta)
	enemy_hurt()
	#Custom Attacks
	hunter_slash_state()
	hunter_bowshot_state()
	#Generic Nav and Anim
	enemy_navigation()
	enemy_animation()
#
#Custom Methods
#
func hunter_ready() -> void:
	#Set Child Nodes
	sprite = $EnemySprite
	animations = $AnimationPlayer
	#effects = $Effects
	healthbar = $HealthBar
	shieldbar = $ShieldBar
	hurt_timer = $HurtTimer
	hurt_box = $HitArea/Hitbox
	attack1 = $Attack1Area
	attack1_box = $Attack1Area/Attack1Damagebox
	attack1_detect = $Navigation/Attack1Detect/Attack1DetectCircle
	attack2 = $Attack2Area
	nav_agent = $Navigation/NavigationAgent2D
	hurt_audio = $HurtSFX
	#Set Stats
	hp = 80
	max_hp = 80
	shield = 0
	max_shield = 0
	shieldbar.visible = false
	speed = 45
	knockback_power= 150
#
func hunter_slash_state() -> void:
	
	if is_attack1 == true && t_atk1D <= 0:
		t_atk1D = t_atk1C
		attack1.targets_hit.clear()
		attack1.damagebox.disabled = false
	if t_atk1C <= 0 && attack1_targets.size() > 0:
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
		animations.play("anim_slash_" + last_dir)
		await animations.animation_finished
		animations.play("anim_idle_" + last_dir)
		last_dir = enemy_attack_dir(attack1_targets)
		enemy_nav_calc()
		is_stopped = false
		attack1.is_attack = false
		attack1.damagebox.disabled = true
		is_attack = false
		is_attack1 = false
#
func hunter_bowshot_state() -> void:
	if is_attack1 == true: return
	if t_atk2C <= 0 && attack2_targets.size() > 0:
		t_atk2C = 180
		t_atk2D = 60
		is_attack = true
		is_attack2 = true
		is_stopped = true
		last_dir = enemy_attack_dir(attack2_targets)
		velocity.x = 0
		velocity.y = 0
		attack2.attack_aud_timer.start()
		target_pos = attack2_targets[0].global_position
		animations.play("anim_bowshot_" + last_dir)
		await animations.animation_finished
		animations.play("anim_idle_" + last_dir)
		enemy_nav_calc()
		#enemy_reposition()
		attack2.is_attack = false
		is_stopped = false
		is_attack = false
		is_attack2 = false
	#
	if is_attack2 == true && t_atk2D <= 0:
		t_atk2D = 60
		var projectile = arrow_scene.instantiate()
		if attack2_targets.size() > 0:
			target_pos = attack2_targets[0].global_position
		projectile.global_position = global_position #spawner.global_position
		projectile.global_position.y = projectile.global_position.y - 8
		projectile.global_rotation = get_angle_to(target_pos)
		get_tree().current_scene.add_child(projectile)

