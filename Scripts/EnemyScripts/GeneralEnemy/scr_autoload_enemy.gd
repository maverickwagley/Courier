#scr_autoload_enemy
#
extends Node
#
@onready var enemy0 = preload("res://Scenes/EnemyEntities/ent_skirmisher.tscn")
@onready var enemy1 = preload("res://Scenes/EnemyEntities/ent_hunter.tscn")
@onready var enemy2 = preload("res://Scenes/EnemyEntities/ent_gorog.tscn")
@onready var enemy_list: Array

func build_enemy_list():
	enemy_list.append(enemy0)
	enemy_list.append(enemy1)
	enemy_list.append(enemy2)
	#enemy_list[0] = enemy0
	#enemy_list[1] = enemy1
	#enemy_list[2] = enemy2
#
#Custom Functions
#
func detect_area_entered():
	pass
