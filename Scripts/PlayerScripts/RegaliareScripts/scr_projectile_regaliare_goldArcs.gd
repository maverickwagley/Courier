#scr_projectile_regaliare_goldArcs
#
extends CharacterBody2D
#
@onready var collision: Area2D = $EnemyCollision
@onready var animations: AnimationPlayer = $AnimationPlayer
@onready var player: CharacterBody2D
@onready var parent: Node2D
#
var SPEED = 0
var sd_timer: int
var direction: Vector2
var ary_collision: Array
var entity_type: int = 2 
var damage: int = 25
var inflict_kb: bool = true
var parent_velocity: Vector2
var type: int = 0
#
#Built-In Methods
#
func _ready():
	collision.damage = damage
	collision.inflict_kb = inflict_kb
	animations.play("anim_goldArcs")
	#direction = Vector2.RIGHT.rotated(global_rotation)
	sd_timer = 90
#
func _physics_process(delta):
	sd_timer = sd_timer - 1
	global_position = parent.global_position
	global_position.y = parent.global_position.y - 3
	visible = true
	if sd_timer < 1:
		queue_free()
#
#Signal Methods
#
func _on_enemy_collision_area_entered(area):
	pass
