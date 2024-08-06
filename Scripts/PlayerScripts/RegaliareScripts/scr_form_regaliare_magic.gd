extends Node2D

class_name Magic

@export var projectile_scene: PackedScene

@onready var flash = preload("res://Scenes/PlayerScenes/RegaliareScenes/ent_particle_goldBolt_flash.tscn")
@onready var sprite: Sprite2D = $MagicSprite #Players Rotating Arm
@onready var spawner: Node2D = $ProjectileSpawn
@onready var magic_audio: AudioStreamPlayer = $MagicSFX
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
			if player.yellow_primary >= 5:
				var projectile = projectile_scene.instantiate()
				autoload_player.part_spawn(flash,spawner.global_position,global_rotation,0.0)
				if autoload_game.audio_mute == false:
					magic_audio.play()
				player.yellow_primary = player.yellow_primary - 5
				player.camera.is_shaking = true
				player.camera.apply_shake(.75)
				player.cursor.form_cursor.visible = true
				player.primary_gui.update()
				projectile.global_position = spawner.global_position
				projectile.global_rotation = sprite.global_rotation
				get_tree().current_scene.add_child(projectile)
				projectile.player = player
