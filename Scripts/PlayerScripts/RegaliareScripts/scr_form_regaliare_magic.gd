#Regaliare Magic Skill
#
extends Node2D
#
@export var projectile_scene: PackedScene
#
@onready var flash = preload("res://Scenes/PlayerScenes/RegaliareScenes/ent_particle_goldBolt_flash.tscn")
@onready var sprite: Sprite2D = $MagicSprite #Players Rotating Arm
@onready var spawner: Node2D = $ProjectileSpawn
@onready var magic_audio: AudioStreamPlayer = $MagicSFX
@onready var parent = get_parent()
@onready var player = CharacterBody2D
#
var last_dir = "down"
var parent_velocity: Vector2
var is_magic: bool = false
var magic_rate: int = 10
var t_magic: int = 0
#
#Built-In Methods
#
func _ready() -> void:
	visible = false
	position.x = 0
	position.y = 0
	t_magic = 0
#
func _physics_process(delta) -> void:
	if t_magic >= 0:
		t_magic = t_magic - 1
	if is_magic == true:
		var rot = get_global_mouse_position()
		look_at(rot)
		match last_dir:
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
				position.x = -1
				position.y = -7
				sprite.flip_v = true
				z_index = 0
			"down":
				position.x = 2
				position.y = -7
				sprite.flip_v = true
				z_index = 0
		#Spawn Projectile
		if t_magic <= 0:
			if player.yellow_primary >= 3:
				var projectile = projectile_scene.instantiate()
				autoload_player.part_spawn(flash,spawner.global_position,global_rotation,0.0)
				if autoload_game.audio_mute == false:
					magic_audio.play()
				player.yellow_primary = player.yellow_primary - 3
				player.camera.is_shaking = true
				player.camera.apply_shake(.75)
				player.cursor.form_cursor.visible = true
				player.primary_gui.update()
				projectile.global_position = spawner.global_position
				projectile.global_rotation = sprite.global_rotation
				get_tree().current_scene.add_child(projectile)
				projectile.player = player
				t_magic = magic_rate
#
#Custom Methods
#
func update() -> void:
	if parent.is_magic == true:
		visible = true
	else:
		visible = false
