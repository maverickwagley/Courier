#scr_projectile_hunter_arrow
#
extends CharacterBody2D
#
@onready var collision: Area2D = $Collision
@onready var particle = preload("res://Scenes/EnemyEntities/ent_particle_arrow.tscn")
@onready var player: CharacterBody2D
#
var fps: float = autoload_game.fps_target
var speed = 250
var sd_timer: float
var direction: Vector2 = Vector2.RIGHT
var damage: float = 15
var inflict_kb: bool = false
var kb_power: float = 0
var parent_velocity: Vector2
var entity_type: int = 2 #Projectile (Player, Enemy, Projectile, NPC)
var type: int = 0
#
#Built-In Functions
#
func _ready():
	collision.damage = damage
	collision.inflict_kb = inflict_kb
	var rand_rot = global_rotation + randf_range(-0.05,0.05)
	direction = Vector2.RIGHT.rotated(rand_rot)
	sd_timer = 60
#
func _physics_process(delta):
	sd_timer = sd_timer - (delta * fps)
	velocity = direction * speed * delta
	var collided = move_and_collide(velocity)
	if collided:
		autoload_player.part_spawn(particle,global_position,global_rotation,-3.14)
		queue_free()
	visible = true
	if sd_timer < 1:
		queue_free()
#
#Signal Functions
#
func _on_enemy_collision_area_entered(area):
	autoload_player.part_spawn(particle,global_position,global_rotation,-3.14)
	queue_free()
#
