extends CharacterBody2D

@onready var collision: Area2D = $EnemyCollision
@onready var animations: AnimationPlayer = $AnimationPlayer
@onready var player: CharacterBody2D

var SPEED = 0
var sd_timer: int
#var direction: Vector2
var direction: Vector2
var ary_collision: Array


var damage: int = 25
var inflict_kb: bool = true
var parent_velocity: Vector2

func _ready():
	#z_index = -1
	collision.damage = damage
	collision.inflict_kb = inflict_kb
	animations.play("anim_goldArcs")
	#direction = Vector2.RIGHT.rotated(global_rotation)
	sd_timer = 60

func _physics_process(delta):
	sd_timer = sd_timer - 1
	print_debug(sd_timer)
	global_position = player.global_position
	#velocity = direction * SPEED * delta
	#var collision = move_and_collide(velocity)
	#if collision:
		#queue_free()
	visible = true
	if sd_timer < 1:
		queue_free()




func _on_enemy_collision_area_entered(area):
	pass
