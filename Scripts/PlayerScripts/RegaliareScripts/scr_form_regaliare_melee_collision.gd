extends Area2D


@onready var shape = $Damagebox
#@onready var player: CharacterBody2D

var parent_velocity: Vector2
var damage: int = 35
var inflict_kb: bool = true
var is_magic: bool = false
var is_kinetic: bool = true
var kb_power: int = 150
var enemy_hit: Array
var type: int = 0



func _ready():
	shape.disabled = true

func enable():
	shape.disabled = false

func disable():
	shape.disabled = true
	enemy_hit.clear()

