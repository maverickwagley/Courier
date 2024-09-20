#Regaliare Special Skill
#
extends Node2D
#
@export var projectile_scene: PackedScene
#
@onready var player: CharacterBody2D
@onready var special_snd: AudioStreamPlayer = $SpecialSFX
#
var parent_velocity: Vector2
var special_rate: int = 90
#
#Built-In Methods
#
	
func regaliare_special_projectile_create() -> void:
	#Move to form controller()
	if autoload_game.audio_mute == false:
		special_snd.play()
	var projectile = projectile_scene.instantiate()
	projectile.global_position = global_position
	projectile.parent = self
	print_debug(global_position)
	#projectile.player = player
	add_child(projectile)
