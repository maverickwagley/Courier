extends CharacterBody2D

@onready var collision: Area2D = $EnemyCollision
@onready var particle: PackedScene = preload("res://Scenes/PlayerScenes/AdavioScenes/ent_particle_voidBolt.tscn")

var speed = 250
var sd_timer: int
#var direction: Vector2
var direction: Vector2 = Vector2.RIGHT


var damage: int = 14
var inflict_kb: bool = false
var is_magic: bool = true
var is_kinetic: bool = false
var kb_power: int = 0
var parent_velocity: Vector2

func _ready():
	collision.damage = damage
	collision.inflict_kb = inflict_kb
	var rand_rot = global_rotation + randf_range(-0.05,0.05)
	direction = Vector2.RIGHT.rotated(rand_rot)
	sd_timer = 40

func _physics_process(delta):
	if sd_timer < 35:
		if damage > 3:
			damage = damage - 1
		if speed > 150:
			speed = speed - 10
	sd_timer = sd_timer - 1
	velocity = direction * speed * delta
	var collision = move_and_collide(velocity)
	if collision:
		autoload_player.part_spawn(particle,global_position,global_rotation,-3.14)
		queue_free()
	visible = true
	if sd_timer < 1:
		queue_free()




func _on_enemy_collision_area_entered(area):
	autoload_player.part_spawn(particle,global_position,global_rotation,-3.14)
	queue_free()
