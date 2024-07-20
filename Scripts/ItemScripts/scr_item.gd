extends CharacterBody2D

@onready var player_collision: Area2D = $PlayerCollision
@onready var item_sprite: Sprite2D = $ItemSprite
@onready var animations: AnimationPlayer = $ItemAnimation


var speed = 25
var sd_timer: int = 3600
var direction: Vector2 = Vector2.RIGHT
var classed: bool = false
var class_update: bool = false

var item_class: int = 0
var item_id: int = 0
var amount: int = randi_range(5,25)
var parent_velocity: Vector2

func _ready():
	global_rotation = global_rotation + randf_range(-3.14,3.14)
	direction = Vector2.RIGHT.rotated(global_rotation)
	update()

func _physics_process(delta):
	if classed == true:
		if class_update == false:
			update()
			class_update = true
	if speed > 0:
		speed = speed - 1
		velocity = direction * speed * delta
	var collision = move_and_collide(velocity)

func update():
	if item_class == 0:
		match item_id:
			0:
				animations.play("anim_item_ess_yellow")
			1:
				animations.play("anim_item_ess_violet")

func update_player(_player):
	if item_class == 0:
		match item_id:
			0:
				_player.yellow_primary = _player.yellow_primary + amount
				_player.primary_gui.update()
			1:
				_player.violet_primary = _player.violet_primary + amount
				_player.primary_gui.update()

func _on_player_collision_area_entered(area):
	var player = area.get_parent()
	update_player(player)
	print_debug("Player Collision")
	queue_free()
	pass # Replace with function body.
