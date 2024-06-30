extends StaticBody2D
@onready var player_collision: Area2D = $PlayerCollision
var speed = 50
var sd_timer: int = 3600
var direction: Vector2 = Vector2.RIGHT

var item_type: int = 0
var item_id: int = 0
var parent_velocity: Vector2

func _ready():
	pass

func _physics_process(delta):
	pass



func _on_player_collision_area_entered(area):
	print_debug("Player Collision")
	queue_free()
	pass # Replace with function body.
