extends CharacterBody2D

@onready var collision: Area2D = $EnemyCollision

var SPEED = 250
var sd_timer: int
#var direction: Vector2
var direction: Vector2 = Vector2.RIGHT


var damage: int = 7
var inflict_kb: bool = false
var parent_velocity: Vector2

func _ready():
	collision.damage = damage
	collision.inflict_kb = inflict_kb
	var rand_rot = global_rotation + randf_range(-0.05,0.05)
	direction = Vector2.RIGHT.rotated(rand_rot)
	sd_timer = 40

func _physics_process(delta):
	sd_timer = sd_timer - 1
	#position = position + direction.normalized() * SPEED * delta
	velocity = direction * SPEED * delta
	var collision = move_and_collide(velocity)
	if collision:
		queue_free()
	visible = true
	if sd_timer < 1:
		queue_free()




func _on_enemy_collision_area_entered(area):
	queue_free()
