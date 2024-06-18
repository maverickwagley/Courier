extends Node2D

class_name Special

@export var projectile_scene: PackedScene

@onready var special_collision: Area2D = $SpecialArea
@onready var parent: Node2D
@onready var player: CharacterBody2D

var parent_velocity: Vector2

var is_special: bool = false
var special_use: bool = false
var t1: int
var t2: int

# Called when the node enters the scene tree for the first time.
func _ready():
	special_collision.disable()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_special == true:
		if special_use == true:
			t1 = t1 - 1
			if t1 <= 0:
				special_collision.enable()
				t1 = 90
			t2 = t2 - 1
			if t2 <= 0:
				for i in 5:
					var projectile = projectile_scene.instantiate()
					projectile.global_position = global_position + projectile.direction.normalized() * 5
					projectile.global_position = global_position
					projectile.global_rotation = (6.28/5) * i
					projectile.z_index = z_index
					get_tree().current_scene.add_child(projectile)
				t2 = 90
		else:
			if Input.is_action_just_pressed("special_skill"):
					is_special = false
					special_use = false
					parent.is_special = false
					parent.is_attack = false
					parent.special_start = false
					parent.special_use = false
					player.is_special = false
					player.is_attack = false
					special_collision.disable()
#
func special_check():
	#Check Line of Sight w/ Raycast
	#special_collision.set_collision_mask_value(6,false)
	var _playPos: Vector2 = player.global_position
	var _cursPos: Vector2 = get_global_mouse_position()
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(_playPos, _cursPos)
	query.set_collision_mask(0b00000000_00000000_00000001_00000000)
	query.exclude = [player]
	var result = space_state.intersect_ray(query)
	if result:
		return true
	else: 
		return false
