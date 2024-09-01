#Adavio Special Collision
#
extends Area2D
#
@onready var shape = $SpecialShape
#
var parent_velocity: Vector2
var damage: int = 35
var inflict_kb: bool = true
var is_magic: bool = true
var is_kinetic: bool = false
var kb_power: int = 250
var enemy_hit: Array
var type: int = 1
#
#Built-In Methods
#
func _ready()  -> void:
	shape.disabled = true
#
#Custom Methods
#
func enable() -> void:
	shape.disabled = false
#
func disable() -> void:
	shape.disabled = true
	enemy_hit.clear()

