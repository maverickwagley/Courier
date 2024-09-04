#Projectile Collision - Hunter Arrow
#
extends Area2D
#
@onready var player: CharacterBody2D
#
var damage: int
var inflict_kb: bool = false
var targets_hit: Array
var enemy_hit: Array
var type: int = 0

