extends Node2D

#dclass_name Special

@export var projectile_scene: PackedScene

@onready var player: CharacterBody2D
@onready var special_snd: AudioStreamPlayer = $SpecialSFX

var parent_velocity: Vector2

var is_special: bool = false
var t1: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	t1 = t1 - 1
	#Spawn Projectile
	if is_special == true:
		if t1 <= 0:
			t1 = 90
			if player.yellow_special >= 100:
				player.yellow_special = player.yellow_special - 100
				player.special_gui.update()
				if ScrGameManager.audio_mute == false:
					special_snd.play()
				var projectile = projectile_scene.instantiate()
				projectile.global_position = player.global_position
				projectile.player = player
				player.add_child(projectile)
			is_special = false
