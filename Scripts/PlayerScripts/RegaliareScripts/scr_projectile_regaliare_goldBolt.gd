#scr_projectile_regaliare_goldBolt
#
extends CharacterBody2D
#
@onready var collision: Area2D = $EnemyCollision
@onready var particle = preload("res://Scenes/PlayerScenes/RegaliareScenes/ent_particle_goldBolt.tscn")
#
var speed: float = 250.0
var sd_timer: int
var direction: Vector2 = Vector2.RIGHT
var entity_type: int = 2 #Projectile (Player, Enemy, Projectile, NPC)
var damage: float = 18.0
var inflict_kb: bool = false
var kb_power: float = 0.0
var parent_velocity: Vector2
var type: int = 0
#
#Built-In Functions
#
func _ready():
	collision.damage = damage
	collision.inflict_kb = inflict_kb
	var rand_rot = global_rotation + randf_range(-0.1,0.1)
	direction = Vector2.RIGHT.rotated(rand_rot)
	sd_timer = 60
#
func _physics_process(delta):
	sd_timer = sd_timer - (delta * 60)
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
	
