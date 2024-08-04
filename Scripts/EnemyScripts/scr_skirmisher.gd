#Enemy Skirmisher
extends CharacterBody2D

class_name Enemy

signal sig_health_changed

@export var speed: int = 45
@export var limit: float = .5
@export var target_node: Node2D = null

@onready var animations: AnimationPlayer = $AnimationPlayer
@onready var effects: AnimationPlayer = $Effects
@onready var hurt_timer: Timer = $HurtTimer
@onready var hurt_areas: Array
@onready var hurt_box = $HitArea/Hitbox
@onready var melee = $MeleeWeapon
@onready var melee_box = $MeleeWeapon
@onready var melee_timer = $MeleeWeapon/MeleeTimer
@onready var melee_detect = $Navigation/MeleeDetect/MeleeDetectCircle
@onready var melee_targets: Array
@onready var nav_agent = $Navigation/NavigationAgent2D
@onready var hurt_audio = $HurtSFX
@onready var blood_particle = preload("res://Scenes/GameScenes/ent_particle_blood.tscn")
@onready var death_particle = preload("res://Scenes/GameScenes/ent_particle_death.tscn")
@onready var item_drop = preload("res://Scenes/ItemScenes/ent_item.tscn")

var hp: int = 69
var max_hp: int = 69
var knockback_power: int = 150
var move_timer: int = randi_range(60,600)
var kb_timer: int = 0
var aggro_timer: int = 0
var _tMelee: int = 0
var objective_num: int = 0
var is_hurt: bool = false
var is_attack: bool = false
var is_melee: bool = false
var is_magic: bool = false
var is_special: bool = false
var is_knockback: bool = false
var is_aggro: bool = false
var is_dead: bool = false
var move_dir: Vector2
var direction = "down"
var last_dir = "down"
var magic_dir = "down"
#
func _ready():
	call_deferred("navigation_setup")
	melee_box.is_melee = false
#
func _physics_process(delta):
	if is_knockback == true:
		kb_timer = kb_timer - 1
		if kb_timer < 1:
			velocity.x = 0
			velocity.y = 0
			is_knockback = false
	melee_state()
	hurt_state()
	update_velocity()
	move_and_slide()
	update_animation()
	aggro_drop()
#
func melee_state():
	if _tMelee > 0:
		_tMelee = _tMelee - 1
	if is_melee == true:
		velocity.x = 0
		velocity.y = 0
		if _tMelee <= 0:
			_tMelee = 90
			melee.melee_aud_timer.start()
			animations.play("anim_skirmisher_slash_" + last_dir)
			await animations.animation_finished
			animations.play("anim_skirmisher_idle_" + last_dir)
			if melee_targets.size() < 1:
				melee_box.is_melee = false
				is_attack = false
				is_melee = false
#
func hurt_state():
	if is_hurt == true:
		print_debug("is_hurt")
		if hurt_areas.size() > 0:
			var _damageArea = hurt_areas[0]
			print_debug(_damageArea)
			if hurt_timer.get_time_left() == 0:
				if ScrEnemyGeneral.hitbox_area_entered(_damageArea,blood_particle,global_position):
					hurt_timer.start()
					hurt_and_damage(_damageArea)
					var _cryChance = randi_range(0,100)
					if _cryChance >= 50:
						if ScrGameManager.audio_mute == false:
							hurt_audio.play()
					if ScrGameManager.audio_mute == false:
						ScrPlayerGeneral.player.damage_dealt_audio.play()
#
func navigation_setup():
	await get_tree().physics_frame
	
	if target_node:
		nav_agent.target_position = target_node.global_position
	else:
		for spawn in get_tree().get_nodes_in_group("EnemyPathPoint"):
			if spawn.name == str(0):
				nav_agent.target_position  = spawn.global_position
#
func update_velocity():
	if is_knockback == true: return
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
func update_animation():
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
#
func hurt_and_damage(area):
	hp = hp - area.damage
	if hp <= 0:
		if is_dead == false:
			is_dead = true
			var current_death = death_particle.instantiate()
			var current_energy = item_drop.instantiate()
			for current_world in get_tree().get_nodes_in_group("World"):
				if current_world.name == "World":
					current_world.add_child(current_death) 
					current_world.call_deferred("add_child",current_energy)
			current_death.global_position = global_position
			current_energy.global_position = global_position
			current_energy.item_class = 0
			current_energy.item_id = area.type
			current_energy.amount = randi_range(5,25)
			current_energy.classed = true
			#current_energy.update()
			queue_free()
	sig_health_changed.emit()
	if area.inflict_kb == true:
		kb_timer = 5
		knockback(area.global_position, area.kb_power)
		is_knockback = true
#
func aggro_drop():
	if is_aggro == false:
		aggro_timer = aggro_timer - 1
		if aggro_timer <= 0:
			target_node = null
#
func knockback(damage_source_pos: Vector2, _kbPower):
	var knockback_dir = damage_source_pos.direction_to(self.global_position)
	velocity = knockback_dir * _kbPower
	move_and_slide()
#
func manual_target_set(_trgt):
	is_aggro = true
	aggro_timer = 300
	target_node = _trgt
#
func _on_melee_detect_area_entered(area):
	if melee_targets.find(area) == -1:
		melee_targets.append(area)
	if is_attack == false:
		is_attack = true
		is_melee = true
		melee_box.is_melee = true
#
func _on_melee_detect_area_exited(area):
	var _targetInd = melee_targets.find(area)
	if _targetInd != -1:
		melee_targets.pop_at(_targetInd)
#
func _on_recalculate_timer_timeout():
	if target_node:
		nav_agent.target_position = target_node.global_position
#
func _on_aggro_detect_area_entered(area):
	is_aggro = true
	aggro_timer = 300
	target_node = area.owner
#
func _on_aggro_drop_area_exited(area):
	is_aggro = false
#
func _on_hitbox_area_entered(area):
	if area == $MeleeWeapon: return
	if area == $HitArea: return
	is_hurt = true
	if hurt_areas.find(area) == -1:
		hurt_areas.append(area)
#
func _on_hitbox_area_exited(area):
	var _targetInd = hurt_areas.find(area)
	if _targetInd != -1:
		hurt_areas.pop_at(_targetInd)
	if hurt_areas.size() <= 0:
		is_hurt = false
#
func _on_melee_audio_timer_timeout():
	melee.melee_audio.play()






