#Enemy (Generic)
#
extends CharacterBody2D
#
class_name Enemy
#
#Standard Attacks
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
#Standard Basics
@onready var nav_agent: NavigationAgent2D
@onready var hurt_audio: AudioStreamPlayer
@onready var target_node: Node2D
@onready var sprite: Sprite2D
@onready var animations: AnimationPlayer
@onready var effects: AnimationPlayer
@onready var health: TextureProgressBar 
@onready var hurt_timer: Timer
@onready var hurt_areas: Array
@onready var hurt_box: CollisionShape2D
@onready var blood_particle = preload("res://Scenes/GameScenes/ent_particle_blood.tscn")
@onready var death_particle = preload("res://Scenes/GameScenes/ent_particle_death.tscn")
@onready var item_drop = preload("res://Scenes/ItemScenes/ent_item.tscn")
#
var hp: int
var max_hp: int
var speed: int
var knockback_power: int
#Status
var objective_num: int = 0
var is_hurt: bool = false
var is_attack: bool = false
var is_attack1: bool = false
var is_attack2: bool = false
var is_attack3: bool = false
var is_knockback: bool = false
var is_aggro: bool = false
var is_dead: bool = false
#Timers
var t_move: int = randi_range(60,600)
var t_knockback: int = 0
var t_aggro: int = 0
var t_atk1: int = 0
var t_atk2: int = 0
var t_atk3: int = 0
#Direction
var move_dir: Vector2
var target_pos: Vector2
var direction = "down"
var last_dir = "down"
var magic_dir = "down"
#
#Custom Methods
#
func enemy_nav_setup() -> void:
	await get_tree().physics_frame
	
	if target_node:
		nav_agent.target_position = target_node.global_position
	else:
		for spawn in get_tree().get_nodes_in_group("EnemyPathPoint"):
			if spawn.name == str(0):
				nav_agent.target_position  = spawn.global_position
#
func enemy_target_set(_trgt) -> void:
	is_aggro = true
	t_aggro = 300
	target_node = _trgt
#
func enemy_reposition() -> void:
	var _newX = global_position.x + randi_range(-16,16)
	var _newY = global_position.y + randi_range(-16,16)
	nav_agent.target_position.x = _newX
	nav_agent.target_position.y = _newY
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
func enemy_apply_damage(area,_essMin,_essMax) -> void:
	hp = hp - area.damage
	if hp <= 0:
		if is_dead == false:
			is_dead = true
			enemy_drop_essence(area.type,_essMin,_essMax)
			var _rType = randi_range(0,5)
			enemy_drop_essence(_rType,_essMin,_essMax)
			#enemy_drop_essence(6,3,7)
			queue_free()
	health.update()
	if area.inflict_kb == true:
		autoload_entity.knockback(self, area.global_position, area.kb_power, 5)
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
func _on_recalculate_timer_timeout() -> void:
	if target_node:
		nav_agent.target_position = target_node.global_position
#
func _on_aggro_detect_area_entered(area) -> void:
	is_aggro = true
	t_aggro = 300
	target_node = area.owner
	print_debug(target_node)
#
func _on_aggro_drop_area_exited(area) -> void:
	is_aggro = false
	#enemy_nav_setup()
#
func _on_hitbox_area_entered(area) -> void:
	#if area == $MeleeWeapon: return
	#if area == $HitArea: return
	is_hurt = true
	sprite.apply_intensity_fade(1.0,0.0,0.25)
	sprite._set("is_hurt",true)
	if hurt_areas.find(area) == -1:
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
