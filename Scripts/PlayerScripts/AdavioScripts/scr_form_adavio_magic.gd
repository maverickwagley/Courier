#scr_form_adavio_magic
#
extends Node2D
#
signal check_cost
signal form_status_set
signal player_status_set
signal player_gui_update
signal player_charge_update
signal player_camera_shake
signal player_cursor_los
#
@export var projectile_scene: PackedScene
#
@onready var flash = preload("res://Scenes/PlayerScenes/AdavioScenes/ent_particle_voidBolt_flash.tscn")
@onready var sprite: Sprite2D = $MagicSprite #Players Rotating Arm
@onready var spawner: Node2D = $ProjectileSpawn
@onready var magic_audio: AudioStreamPlayer = $MagicSFX
@onready var player: CharacterBody2D
#
var parent_velocity: Vector2
var cursor_los_check: bool = false
var cost_check: bool = false
var magic_cost = 20
var t_magic: int
var is_magic = false
var last_dir = "down"
#
#Built-In Functions
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
		emit_signal("check_cost","violet_primary",magic_cost)
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
		if t_magic <= 0:
			t_magic = 50
			if cost_check == true:
				projectile_create()
#
#Custom Functions
#
func projectile_create():
	autoload_player.part_spawn(flash,spawner.global_position,global_rotation,0.0)
	if autoload_game.audio_mute == false:
		magic_audio.play()
	emit_signal("player_charge_update","violet_primary",-(magic_cost))
	for i in 7:
		var projectile = projectile_scene.instantiate()
		emit_signal("player_camera_shake",3)
		emit_signal("player_gui_update")
		projectile.global_position = spawner.global_position 
		projectile.global_rotation = sprite.global_rotation - .45 + (.15 * i)
		get_tree().current_scene.add_child(projectile)
		projectile.z_index = 0
#
func update() -> void:
	if is_magic == true:
		visible = true
	else:
		visible = false
