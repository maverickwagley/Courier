extends Area2D


@onready var shape = $MeleeShape

var parent_velocity: Vector2
var damage: int = 35
var inflict_kb: bool = true
var enemy_hit: Array


func _ready():
	shape.disabled = true

func enable():
	shape.disabled = false

func disable():
	shape.disabled = true
	enemy_hit.clear()

