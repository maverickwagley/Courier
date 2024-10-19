#scr_attack_area (Generic)
#
extends Area2D
#
class_name AttackArea
#
@onready var shape: CollisionShape2D
@onready var attack_audio: AudioStreamPlayer
@onready var attack_aud_timer: Timer
#
var parent_velocity: Vector2
var damage: float
var inflict_kb: bool
var is_attack: bool
var is_magic: bool
var is_kinetic: bool
var kb_power: float
var target_hit: Array
var type: int
#
#Custom Functions
#
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
