extends Node2D

#dclass_name Special

@export var projectile_scene: PackedScene

@onready var player: CharacterBody2D

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
			var projectile = projectile_scene.instantiate()
			#projectile.parent_velocity = parent_velocityd
			#projectile.direction = Vector2.from_angle(sprite.global_rotation)
			projectile.global_position = player.global_position
			projectile.player = player
			player.add_child(projectile)
			is_special = false
