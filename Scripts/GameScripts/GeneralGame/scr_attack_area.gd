#scr_attack_area (Generic)
#
extends Area2D
#
class_name AttackArea
#
@onready var shape: CollisionShape2D
#
var parent_velocity: Vector2
var damage: int
var inflict_kb: bool
var is_magic: bool
var is_kinetic: bool
var kb_power: int
var target_hit: Array
var type: int
#
#Custom Methods
func enable() -> void:
	shape.disabled = false
#
func disable() -> void:
	shape.disabled = true
	target_hit.clear()
#
func attack_collision_standard() -> bool:
	print_debug("Standard Attack Area Collision")
	return true
