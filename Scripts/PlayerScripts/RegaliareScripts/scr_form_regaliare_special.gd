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
var is_special: bool = false
var special_rate: int = 90
var t_special: int = 0
#
#Built-In Methods
#
func _process(delta) -> void:
	if t_special >= 0:
		t_special = t_special - 1
	if is_special == true:
		if t_special <= 0:
			if player.yellow_special >= 100:
				player.yellow_special = player.yellow_special - 100
				player.special_gui.update()
				if autoload_game.audio_mute == false:
					special_snd.play()
				var projectile = projectile_scene.instantiate()
				projectile.global_position = player.global_position
				projectile.player = player
				player.add_child(projectile)
				t_special = special_rate
			is_special = false
