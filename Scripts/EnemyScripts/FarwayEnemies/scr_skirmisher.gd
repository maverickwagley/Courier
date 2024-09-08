#Enemy Skirmishers
#
extends Enemy
#
#Built-In Methods
#
func _ready() -> void:
	skirmisher_ready()
	call_deferred("enemy_nav_calc")
#
func _physics_process(_delta) -> void:
	skirmisher_slash_state()
	enemy_hurt()
	enemy_navigation()
	skirmisher_animation()
#
#Custom Methods
#
func skirmisher_ready() -> void:
	#Set Child Nodes
	sprite = $EnemySprite
	animations = $AnimationPlayer
	effects = $Effects
	healthbar = $HealthBar
	shieldbar = $ShieldBar
	hurt_timer = $HurtTimer
	hurt_box = $HitArea/Hitbox
	attack1 = $Attack1Area
	attack1_box = $Attack1Area/Attack1Damagebox
	attack1_timer = $Attack1Area/Attack1Timer
	attack1_detect = $Navigation/Attack1Detect/Attack1DetectCircle
	nav_agent = $Navigation/NavigationAgent2D
	hurt_audio = $HurtSFX
	#Set Stats
	hp = 70
	max_hp = 70
	shield = 0
	max_shield = 0
	shieldbar.visible = false
	speed = 45
	knockback_power= 150
#
func skirmisher_slash_state() -> void:
	if t_atk1 > 0:
		t_atk1 = t_atk1 - 1
	if t_atk1 <= 0 && attack1_targets.size() > 0:
			is_attack1 = true
			is_attack = true
			t_atk1 = 90
			velocity.x = 0
			velocity.y = 0
			attack1.attack_aud_timer.start()
			animations.play("anim_skirmisher_slash_" + last_dir)
			await animations.animation_finished
			animations.play("anim_skirmisher_idle_" + last_dir)
			last_dir = enemy_attack_dir(attack1_targets)
			attack1.targets_hit.clear()
			attack1.is_attack = false
			is_attack = false
			is_attack1 = false
#
func skirmisher_animation() -> void:
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
		
		animations.play("anim_skirmisher_run_" + direction)
	else:
		animations.play("anim_skirmisher_idle_" + last_dir)


