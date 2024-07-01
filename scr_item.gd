extends CharacterBody2D

@onready var player_collision: Area2D = $PlayerCollision

var speed = 25
var sd_timer: int = 3600
var direction: Vector2 = Vector2.RIGHT

var item_type: int = 0
var item_id: int = 0
var amount: int = randi_range(5,25)
var parent_velocity: Vector2

func _ready():
	global_rotation = global_rotation + randf_range(-3.14,3.14)
	direction = Vector2.RIGHT.rotated(global_rotation)

func _physics_process(delta):
	if speed > 0:
		speed = speed - 1
		velocity = direction * speed * delta
	var collision = move_and_collide(velocity)



func _on_player_collision_area_entered(area):
	var player = area.get_parent()
	player.yellow_primary = player.yellow_primary + amount
	player.primary_gui.update()
	print_debug("Player Collision")
	queue_free()
	pass # Replace with function body.
