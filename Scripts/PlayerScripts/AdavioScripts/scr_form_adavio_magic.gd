extends Node2D

#class_name Magic

@export var projectile_scene: PackedScene

@onready var sprite = $Sprite2D #Players Rotating Arm
@onready var spawner = $ProjectileSpawn
@onready var player: CharacterBody2D
@onready var parent = get_parent()

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
				z_index =0

		
		#Spawn Projectile
		if t1 <= 0:
			t1 = 30
			for i in 5:
				var projectile = projectile_scene.instantiate()
				#projectile.global_position = global_position + projectile.direction.normalized() * 10
				player.camera.is_shaking = true
				player.camera.apply_shake(3)
				projectile.global_position = spawner.global_position 
				projectile.global_rotation = sprite.global_rotation - .2 + (.1 * i)
				get_tree().current_scene.add_child(projectile)
				projectile.z_index = 0
