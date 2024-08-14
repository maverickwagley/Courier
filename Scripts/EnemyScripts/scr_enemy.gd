#Enemy (Generic)
#
extends CharacterBody2D
#
class_name Enemy
#
@export var speed: int = 45
@export var limit: float = .5
@export var target_node: Node2D = null
#
@onready var sprite: Sprite2D
@onready var animations: AnimationPlayer
@onready var effects: AnimationPlayer
@onready var health: TextureProgressBar 
@onready var hurt_timer: Timer
@onready var hurt_areas: Array
@onready var hurt_box: CollisionShape2D
@onready var melee: Area2D
@onready var melee_box: CollisionShape2D
@onready var melee_timer: Timer
@onready var melee_detect: CollisionShape2D
@onready var melee_targets: Array
@onready var nav_agent: NavigationAgent2D
@onready var hurt_audio: AudioStreamPlayer
@onready var blood_particle = preload("res://Scenes/GameScenes/ent_particle_blood.tscn")
@onready var death_particle = preload("res://Scenes/GameScenes/ent_particle_death.tscn")
@onready var item_drop = preload("res://Scenes/ItemScenes/ent_item.tscn")
#
var hp: int = 70
var max_hp: int = 70
var knockback_power: int = 150
#Status
var objective_num: int = 0
var is_hurt: bool = false
var is_attack: bool = false
var is_melee: bool = false
var is_magic: bool = false
var is_special: bool = false
var is_knockback: bool = false
var is_aggro: bool = false
var is_dead: bool = false
#Timers
var t_move: int = randi_range(60,600)
var t_knockback: int = 0
var t_aggro: int = 0
var t_melee: int = 0
#Direction
var move_dir: Vector2
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
func enemy_aggro_drop() -> void:
	if is_aggro == false:
		t_aggro = t_aggro - 1
		if t_aggro <= 0:
			target_node = null
#
func enemy_apply_damage(area) -> void:
	hp = hp - area.damage
	if hp <= 0:
		if is_dead == false:
			is_dead = true
			enemy_drop_essence(area.type,10,15)
			var _rType = randi_range(0,5)
			enemy_drop_essence(_rType,5,25)
			enemy_drop_essence(6,3,7)
			#current_energy.update()
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
