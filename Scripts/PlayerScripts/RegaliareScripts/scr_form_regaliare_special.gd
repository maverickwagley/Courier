extends Node2D

#dclass_name Special

@export var projectile_scene: PackedScene

@onready var player: CharacterBody2D
@onready var special_snd: AudioStreamPlayer = $SpecialSFX

var parent_velocity: Vector2

var is_special: bool = false
var special_rate: int = 90
var t_special: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if t_special >= 0:
		t_special = t_special - 1
	#Spawn Projectile
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
