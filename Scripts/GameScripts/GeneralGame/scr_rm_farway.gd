#Room Farway
#
extends Node2D
#
@export var player_scene: PackedScene
@onready var tilemap = $TileMap
#
var enemy_count: int = 0
var enemy_spawn_timer: int = 0
var form_menu: bool = false
#
var enemy0 = preload("res://Scenes/EnemyEntities/ent_skirmisher.tscn")
var enemy1 = preload("res://Scenes/EnemyEntities/ent_hunter.tscn")
var enemy2 = preload("res://Scenes/EnemyEntities/ent_gorog.tscn")
#
#Built-In Methods
#
func _ready():
	print_debug("Mode:" + str(autoload_game.mode))
	if autoload_game.mode == 1:
		var current_player = player_scene.instantiate()
		add_child(current_player)
		for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
			if spawn.name == str(0):
				current_player.global_position = spawn.global_position
				current_player.tilemap = tilemap
				current_player.update_cam_tilemap()
				current_player.room_space = self
		autoload_player.player = current_player
		pass
		
	if autoload_game.mode == 2:
		var current_player = player_scene.instantiate()
		add_child(current_player)
		for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
			if spawn.name == str(0):
				current_player.global_position = spawn.global_position
				current_player.tilemap = tilemap
				current_player.room_space = self
		pass 
#
func _process(delta):
	farway_enemy_spawner()
#
#Custom Methods
#
func farway_enemy_spawner():
	if enemy_count < 1:
		if enemy_spawn_timer > 0:
			enemy_spawn_timer = enemy_spawn_timer - 1
		if enemy_spawn_timer <= 0:
			enemy_count = enemy_count + 1
			enemy_spawn_timer = 600
			farway_wave_main()
#
func farway_wave_main():
	var current_enemy0 = enemy0.instantiate()
	#var current_enemy1 = enemy0.instantiate()
	#var current_enemy2 = enemy0.instantiate()
	#var current_enemy3 = enemy1.instantiate()
	#var current_enemy4 = enemy1.instantiate()
	#var current_enemy5 = enemy2.instantiate()
	add_child(current_enemy0)
	#add_child(current_enemy1)
	#add_child(current_enemy2)
	#add_child(current_enemy3)
	#add_child(current_enemy4)
	#add_child(current_enemy5)
	for spawn in get_tree().get_nodes_in_group("EnemySpawnPoint"):
		if spawn.name == str(0):
			current_enemy0.global_position = spawn.global_position
		#if spawn.name == str(1):
			#current_enemy1.global_position = spawn.global_position
		#if spawn.name == str(2):
			#current_enemy2.global_position = spawn.global_position
		#if spawn.name == str(3):
			#current_enemy3.global_position = spawn.global_position
		#if spawn.name == str(4):
			#current_enemy4.global_position = spawn.global_position
		#if spawn.name == str(5):
			#current_enemy5.global_position = spawn.global_position
##
func _on_inventory_gui_closed():
	get_tree().paused = false

func _on_inventory_gui_opened():
	get_tree().paused = true
