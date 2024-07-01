#Enemy Skirmisher
extends CharacterBody2D

class_name Enemy

signal sig_health_changed

@export var speed: int = 45
@export var limit: float = .5
@export var target_node: Node2D = null

@onready var animations = $AnimationPlayer
@onready var effects = $Effects
@onready var hurt_timer = $HurtTimer
@onready var hurt_box = $HitArea/Hitbox
@onready var melee = $MeleeWeapon
@onready var melee_box = $MeleeWeapon
@onready var melee_timer = $MeleeWeapon/MeleeTimer
@onready var nav_agent = $Navigation/NavigationAgent2D
@onready var blood_particle = preload("res://Scenes/ent_particle_blood.tscn")
@onready var death_particle = preload("res://Scenes/ent_particle_death.tscn")
@onready var item_drop = preload("res://Scenes/ItemScenes/ent_item.tscn")

var hp: int = 69
var max_hp: int = 69
var knockback_power: int = 150
var move_timer: int = randi_range(60,600)
var kb_timer: int = 0
var aggro_timer: int = 0
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

func _ready():
	call_deferred("navigation_setup")
	melee_box.is_melee = false

func _physics_process(delta):
	if is_knockback == true:
		kb_timer = kb_timer - 1
		if kb_timer < 1:
			velocity.x = 0
			velocity.y = 0
			is_knockback = false
	update_velocity()
	move_and_slide()
	update_animation()
	aggro_drop()

func navigation_setup():
	await get_tree().physics_frame
	
	if target_node:
		nav_agent.target_position = target_node.global_position
	else:
		for spawn in get_tree().get_nodes_in_group("EnemyPathPoint"):
			if spawn.name == str(0):
				nav_agent.target_position  = spawn.global_position

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
			current_energy.amount = randi_range(5,25)
			queue_free()
	sig_health_changed.emit()
	is_hurt = true
	if area.inflict_kb == true:
		kb_timer = 5
		knockback(area.global_position)
		is_knockback = true
	effects.play("anim_hurt_blink")
	hurt_timer.start()
	await hurt_timer.timeout
	effects.play("RESET")
	is_hurt = false

func aggro_drop():
	if is_aggro == false:
		aggro_timer = aggro_timer - 1
		if aggro_timer <= 0:
			target_node = null

func knockback(damage_source_pos: Vector2):
	var knockback_dir = damage_source_pos.direction_to(self.global_position)
	velocity = knockback_dir * knockback_power
	move_and_slide()

func manual_target_set(_trgt):
	is_aggro = true
	aggro_timer = 300
	target_node = _trgt

func _on_melee_detect_area_entered(area):
	if is_attack == false:
		is_attack = true
		is_melee = true
		melee_box.is_melee = true
		velocity.x = 0
		velocity.y = 0
		animations.play("anim_skirmisher_slash_" + last_dir)
		await animations.animation_finished
		melee_box.is_melee = false
		is_attack = false
		is_melee = false

func _on_recalculate_timer_timeout():
	if target_node:
		nav_agent.target_position = target_node.global_position

func _on_aggro_detect_area_entered(area):
	is_aggro = true
	aggro_timer = 300
	target_node = area.owner

func _on_aggro_drop_area_exited(area):
	is_aggro = false

func _on_hitbox_area_entered(area):
	if area == $MeleeWeapon: return
	if area == $HitArea: return
	ScrEnemyGeneral.hitbox_area_entered(area,blood_particle,global_position)
	hurt_and_damage(area)
	#if area == $MeleeWeapon: return
	#if area == $HitArea: return
	##if is_hurt == true: return
	#if area.enemy_hit.find(self) == -1:
		#area.enemy_hit.append(self)
		#var _partChance = randi_range(0,1)
		#if _partChance == 0:
			#var current_part = blood_particle.instantiate()
			#for current_world in get_tree().get_nodes_in_group("World"):
				#if current_world.name == "World":
					#current_world.add_child(current_part) 
			#current_part.particle.amount = randi_range(1,3)
			#current_part.global_position = global_position
			#current_part.global_rotation = area.global_rotation - 3.14
		#hurt_and_damage(area)
