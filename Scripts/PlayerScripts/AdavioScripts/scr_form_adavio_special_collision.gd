extends Area2D


@onready var shape = $SpecialShape

var parent_velocity: Vector2
var damage: int = 35
var inflict_kb: bool = true
var kb_power: int = 250
var enemy_hit: Array
var type: int = 1


func _ready():
	shape.disabled = true

func enable():
	shape.disabled = false

func disable():
	shape.disabled = true
	enemy_hit.clear()

