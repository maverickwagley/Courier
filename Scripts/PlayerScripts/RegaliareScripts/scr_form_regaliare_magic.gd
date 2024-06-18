extends Node2D

class_name Magic

@export var projectile_scene: PackedScene

@onready var sprite = $Sprite2D #Players Rotating Arm
@onready var spawner = $ProjectileSpawn
@onready var parent = get_parent()
@onready var player = CharacterBody2D

var parent_velocity: Vector2

var t1: int
var is_magic = false

func _ready():
	visible = false
	position.x = 0
	position.y = 0
	t1 = 0

func update():
	if parent.is_magic == true:
		visible = true
	else:
		visible = false

func _physics_process(delta):
	t1 = t1 - 1
	if parent.is_magic == true:
		var rot = get_global_mouse_position()
		look_at(rot)
		#if parent.is_magic == true:
		match parent.last_dir:
			"right":
				position.x = 0
				position.y = -7
				sprite.flip_v = false
				z_index = - 1
			"up":
				position.x = -2
				position.y = -6
				sprite.flip_v = true
				z_index = - 1
			"left":
				position.x = -2
				position.y = -7
				sprite.flip_v = true
				z_index = 0
			"down":
				position.x = 2
				position.y = -7
				sprite.flip_v = true
				z_index = 0

		
		#Spawn Projectile
		if t1 <= 0:
			t1 = 10
			var projectile = projectile_scene.instantiate()
			#projectile.parent_velocity = parent_velocity
			#var spr_rot = sprite.rotation
			#print_debug(spr_rot)
			#projectile.didrection = Vector2.from_angle(spr_rot)
			#projecddtile.global_position = global_position + projectile.direction.normalized() * 5
			projectile.global_position = spawner.global_position #+ projectile.direction.normalized() * 5
			projectile.global_rotation = sprite.global_rotation
			#projectile.player = player
			print_debug(str(get_tree().root))
			get_tree().current_scene.add_child(projectile)
