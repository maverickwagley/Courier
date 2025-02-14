#scr_enemy (Generic)
#
extends CharacterBody2D
#
class_name Enemy
#
#Standard Attacks and Skills
@onready var attack1: Area2D
@onready var attack1_box: CollisionShape2D
@onready var attack1_timer: Timer
@onready var attack1_detect: CollisionShape2D
@onready var attack1_targets: Array
@onready var attack2: Area2D
@onready var attack2_box: CollisionShape2D
@onready var attack2_timer: Timer
@onready var attack2_detect: CollisionShape2D
@onready var attack2_targets: Array
@onready var attack3: Area2D
@onready var attack3_box: CollisionShape2D
@onready var attack3_timer: Timer
@onready var attack3_detect: CollisionShape2D
@onready var attack3_targets: Array
@onready var shield_detect: CollisionShape2D
@onready var shield_targets: Array
#Standard Basics
@onready var nav_agent: NavigationAgent2D
@onready var hurt_audio: AudioStreamPlayer
@onready var shielded_audio: AudioStreamPlayer
@onready var target_node: CharacterBody2D
@onready var sprite: Sprite2D
@onready var animations: AnimationPlayer
@onready var effects: AnimationPlayer
@onready var healthbar: TextureProgressBar 
@onready var shieldbar: TextureProgressBar
@onready var hurt_timer: Timer
@onready var hurt_areas: Array
@onready var hurt_box: CollisionShape2D
@onready var enemy_marker: Sprite2D
@onready var blood_particle = preload("res://Scenes/GameScenes/ent_particle_blood.tscn")
@onready var death_particle = preload("res://Scenes/GameScenes/ent_particle_death.tscn")
@onready var item_drop = preload("res://Scenes/ItemScenes/ent_item.tscn")
#
var fps: float = autoload_game.fps_target
var hp: float
var max_hp: float
var speed: float
var shield: float
var max_shield: float
var knockback_power: float
var entity_type:float = 1
#Status
var objective_num: float = 0
var is_hurt: bool = false
var is_invincible: bool = false
var is_attack: bool = false
var is_attack1: bool = false
var is_attack2: bool = false
var is_attack3: bool = false
#var is_shield_range: bool = false
var is_knockback: bool = false
var is_shielded: bool = false
var is_aggro: bool = true
var is_stopped: bool = false
var is_dead: bool = false
#Timers: These Need converted to float
var t_move: float = randi_range(60,600)
var t_knockback: float = 0
var t_hurt: float = 0
var t_shield: float = 0
var t_aggro: float = 0
var t_atk1C: float = 0 #Cooldown
var t_atk1D: float = 0 #Delay
var t_atk1S: float = 0 #Special
var t_atk2C: float = 0
var t_atk2D: float = 0
var t_atk2S: float = 0
var t_atk3C: float = 0
var t_atk3D: float = 0
var t_atk3S: float = 0
#Direction
var move_dir: Vector2
var target_pos: Vector2
var direction = "down"
var last_dir = "down"
var magic_dir = "down"
#
#Custom Functions
#
func enemy_timers(delta) -> void:
	if t_atk1C > 0:
		t_atk1C = t_atk1C - (delta * fps)
	if t_atk1D > 0:
		t_atk1D = t_atk1D - (delta * fps)
	if t_atk1S > 0:
		t_atk1S = t_atk1S - (delta * fps)
	if t_atk2C > 0:
		t_atk2C = t_atk2C - (delta * fps)
	if t_atk2D > 0:
		t_atk2D = t_atk2D - (delta * fps)
	if t_atk2S > 0:
		t_atk2S = t_atk2S - (delta * fps)
	if t_atk3C > 0:
		t_atk3C = t_atk3C - (delta * fps)
	if t_atk3D > 0:
		t_atk3D = t_atk3D - (delta * fps)
	if t_atk3S > 0:
		t_atk3S = t_atk3S - (delta * fps)
	if t_hurt > 0:
		t_hurt = t_hurt - (delta * fps)
#
func enemy_nav_calc() -> void:
	await get_tree().physics_frame
	for p in get_tree().get_nodes_in_group("Player"):
		target_node = p
	if target_node:
		nav_agent.target_position = target_node.global_position
#
func enemy_target_set(_trgt) -> void:
	is_aggro = true
	t_aggro = 300
	target_node = _trgt
#
func enemy_attack_dir(_array: Array):
	if _array.size() >= 1:
		var targetPos = _array[0].global_position
		targetPos.y = targetPos.y
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
func enemy_aggro_drop() -> void:
	pass
#
func enemy_hurt() -> void:
	#CM: _physics_process()
	if is_hurt == true:
		if hurt_areas.size() > 0:
			if t_hurt <= 0:
				for i in hurt_areas.size():
					var _damageArea = hurt_areas[i]
					if enemy_hitbox_area_entered(_damageArea,blood_particle,global_position) == true:
						enemy_apply_damage(_damageArea,3,7)
				var _cryChance = randi_range(0,100)
				if _cryChance >= 50:
					if autoload_game.audio_mute == false:
						hurt_audio.play()
				if autoload_game.audio_mute == false:
					autoload_player.player.damage_dealt_audio.play()
				t_hurt = 9
#
func enemy_hitbox_area_entered(area,particle,global_position) -> bool:
	if area.target_hit.find(get_instance_id()) == -1:
		area.target_hit.append(get_instance_id())
		var _partChance = randi_range(0,1)
		if _partChance == 0:
			var current_part = particle.instantiate()
			for current_world in get_tree().get_nodes_in_group("World"):
				if current_world.name == "World":
					current_world.add_child(current_part) 
			current_part.particle.amount = randi_range(1,3)
			current_part.global_position = global_position
			current_part.global_rotation = area.global_rotation - PI
		#print_debug("Damage dealt")
		return true
	else:
		#print_debug("Could not append")
		return false
#
func enemy_apply_damage(area,_essMin,_essMax) -> void:
	if is_shielded == false:
		hp = hp - area.damage
	else:
		if shield > 0:
			if shield >= area.damage:
				shield = shield - area.damage
			else:
				hp = hp - (area.damage - shield)
				shield = 0
		else:
			hp = hp - area.damage
	if area.inflict_kb == true:
		autoload_entity.knockback(self, area.global_position, area.kb_power, 5)
	if hp <= 0:
		if is_dead == false:
			is_dead = true
			enemy_drop_essence(area.type,_essMin,_essMax)
			var _rType = randi_range(0,5)
			enemy_drop_essence(_rType,_essMin,_essMax)
			#enemy_drop_essence(6,3,7)
			autoload_game.enemy_count = autoload_game.enemy_count - 1
			autoload_game.room.update_labels()
			queue_free()
	if hp > 0:
		healthbar.value = hp * 100 / max_hp
	if shield > 0:
		shieldbar.value = shield * 100 / max_shield
	#healthbar.update()
#
func enemy_navigation(delta) -> void:
	#CM: _physics_process() Per Enemy
	if is_knockback == true:
		move_and_slide()
		enemy_knockback_stack()
		t_knockback = t_knockback - (delta * fps)
		if t_knockback < 1:
			velocity.x = 0
			velocity.y = 0
			is_knockback = false
		return
	if is_stopped == true: return
	if nav_agent.is_navigation_finished():
		#print_debug("nav finished")
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
	#if is_attack == true: 
		#return
	var axis = to_local(nav_agent.get_next_path_position()).normalized()
	var intended_vel = axis * speed
	nav_agent.set_velocity(intended_vel)
#
func enemy_knockback_stack() -> void:
	if is_knockback == true:
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			if collider.is_class("CharacterBody2D"):
				if collider.entity_type == 1:
					if collider.is_knockback == false:
						autoload_entity.knockback(collider, global_position, knockback_power, t_knockback)
						collider.is_knockback = true
#
func enemy_animation() -> void:
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
		
		animations.play("anim_run_" + direction)
	else:
		animations.play("anim_idle_" + last_dir)
#
func enemy_drop_essence(_id,_min,_max) -> void:
	var current_death = death_particle.instantiate()
	var current_energy = item_drop.instantiate()
	for current_world in get_tree().get_nodes_in_group("World"):
		if current_world.name == "World":
			current_world.add_child(current_death) 
			current_world.call_deferred("add_child",current_energy)
	current_death.global_position = global_position
	current_energy.global_position = global_position
	current_energy.item_class = 0
	current_energy.item_id = _id
	current_energy.amount = randi_range(_min,_max)
	current_energy.classed = true
#
#Signal Functions
#
func _on_attack1_detect_area_entered(area) -> void:
	if attack1_targets.find(area) == -1:
		attack1_targets.append(area)
		#is_attack1 = true
	if is_attack == false:
		is_attack = true
		#is_attack1 = true
		attack1.is_attack = true
#
func _on_attack1_detect_area_exited(area) -> void:
	var _targetInd = attack1_targets.find(area)
	if _targetInd != -1:
		attack1_targets.pop_at(_targetInd)
#
func _on_attack2_detect_area_entered(area):
	if attack2_targets.find(area) == -1:
		attack2_targets.append(area)
		#is_attack2 = true
	#pass
	if is_attack == false:
		is_attack = true
		attack2.is_attack = true
#
func _on_attack2_detect_area_exited(area):
	#pass
	var _targetInd = attack2_targets.find(area)
	if _targetInd != -1:
		attack2_targets.pop_at(_targetInd)
#
func _on_shield_detect_area_entered(area) -> void:
	if shield_targets.find(area) == -1:
		shield_targets.append(area)
		#is_attack1 = true
	if is_attack == false:
		is_attack = true
		#is_shield_range = true
#
func _on_shield_detect_area_exited(area) -> void:
	var _targetInd = shield_targets.find(area)
	if _targetInd != -1:
		shield_targets.pop_at(_targetInd)
#
func _on_recalculate_timer_timeout() -> void:
	enemy_nav_calc()
#
func _on_aggro_detect_area_entered(area) -> void:
	is_aggro = true
	t_aggro = 300
	target_node = area.owner
#
func _on_hitbox_area_entered(area) -> void:
	t_hurt = 0
	is_hurt = true
	if is_shielded == true:
		sprite.apply_intensity_fade(0.5,0.0,0.25)
		sprite._set("is_shielded",true)
		if autoload_game.audio_mute == false:
			shielded_audio.play()
	else:
		sprite.apply_intensity_fade(1.0,0.0,0.5)
		sprite._set("is_hurt",true)
	
	if hurt_areas.find(area) == -1:
		area.collide()
		hurt_areas.append(area)
#
func _on_hitbox_area_exited(area) -> void:
	var _targetInd = hurt_areas.find(area)
	if _targetInd != -1:
		hurt_areas.pop_at(_targetInd)
	if hurt_areas.size() <= 0:
		is_hurt = false
#
func _on_attack1_audio_timer_timeout() -> void:
	if autoload_game.audio_mute == false:
		attack1.attack_audio.play()
#
func _on_navigation_velocity_computed(safe_velocity):
	if is_stopped == true: return
	if is_knockback == true: return
	velocity = safe_velocity
	move_and_slide()
