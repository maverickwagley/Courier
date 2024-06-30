extends CharacterBody2D

@onready var collision: Area2D = $EnemyCollision
@onready var particle = preload("res://Scenes/PlayerScenes/RegaliareScenes/ent_particle_goldBolt.tscn")

var speed = 250
var sd_timer: int
#var direction: Vector2
var direction: Vector2 = Vector2.RIGHT


var damage: int = 6
var inflict_kb: bool = false
var parent_velocity: Vector2

func _ready():
	collision.damage = damage
	collision.inflict_kb = inflict_kb
	var rand_rot = global_rotation + randf_range(-0.1,0.1)
	direction = Vector2.RIGHT.rotated(rand_rot)
	sd_timer = 60

func _physics_process(delta):
	sd_timer = sd_timer - 1
	#position = position + direction.normalized() * SPEED * delta
	velocity = direction * speed * delta
	var collision = move_and_collide(velocity)
	if collision:
		ScrPlayerGeneral.part_spawn(particle,global_position,global_rotation)
		queue_free()
	visible = true
	if sd_timer < 1:
		queue_free()


func _on_enemy_collision_area_entered(area):
	ScrPlayerGeneral.part_spawn(particle,global_position,global_rotation)
	queue_free()
	
