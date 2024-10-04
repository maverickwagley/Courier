#Room Farway
#
extends Node2D
#
@export var player_scene: PackedScene
@onready var tilemap: TileMapLayer = $TileMap/Base
@onready var game_hud: CanvasLayer = $GameHUD
@onready var enemy_prog: TextureProgressBar = $GameHUD/EnemyProgress
@onready var wave_label: Label = $GameHUD/EnemyProgress/WaveLabel
@onready var enemy_label: Label = $GameHUD/EnemyProgress/EnemyLabel
#@onready var groupA: Node2D = $Markers/EnemySpawns/SpawnGroupA
#
var local_wave: int = 1
var game_wave: int = 1
var enemy_count: int = 0
var max_squads: int = 4
var squad_size: int = 1
var rem_squads: int = 4
var squad_comp: Array
var enemy_spawn_timer: int = 0
var prewave = 60
var wave_started: bool = false
var form_menu: bool = false
#Spawner Variables
var group_array: Array
var group_num: int = 0
var group_rand: int
var spawn_dist: float
var spawn0: String = "00"
var spawn1: String = "01"
var spawn2: String = "02"
var spawn3: String = "03"
var spawn4: String = "04"
var spawn5: String = "05"
var current_enemy0: CharacterBody2D 
var current_enemy1: CharacterBody2D
var current_enemy2: CharacterBody2D
var current_enemy3: CharacterBody2D
var current_enemy4: CharacterBody2D
var current_enemy5: CharacterBody2D
#
var enemy0 = preload("res://Scenes/EnemyEntities/ent_skirmisher.tscn")
var enemy1 = preload("res://Scenes/EnemyEntities/ent_hunter.tscn")
var enemy2 = preload("res://Scenes/EnemyEntities/ent_gorog.tscn")
#
#Built-In Methods
#
func _ready() -> void:
	print_debug("Mode:" + str(autoload_game.mode))
	if autoload_game.mode == 1:
		var current_player = player_scene.instantiate()
		add_child(current_player)
		for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
			if spawn.name == str(0):
				current_player.global_position = spawn.global_position
				current_player.tilemap = tilemap
				current_player.player_update_cam_tilemap()
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
func _physics_process(_delta) -> void:
	if wave_started == false:
		if prewave > 0:
			prewave = prewave - 1
		if prewave < 0:
			prewave = 1800
	if wave_started == true:
		farway_enemy_spawner()
#
#Custom Methods
#
func farway_enemy_spawner() -> void:
	if rem_squads > 0:
		if enemy_spawn_timer > 0:
			enemy_spawn_timer = enemy_spawn_timer - 1
		if enemy_spawn_timer <= 0:
			rem_squads = rem_squads - 1
			enemy_spawn_timer = 300
			enemy_prog.update_enemy_progress((rem_squads) * 100/max_squads)
			farway_spawn_group_select()
			farway_spawn_comp_add()
			room_instantiate_enemy()
			#farway_wave_main()
			update_labels()
#
func farway_spawn_group_select() -> void:
	#Spawner Group Selection
	for group in get_tree().get_nodes_in_group("EnemySpawnGroup"):
		if group.collision_list.size() <= 0:
			match group.name:
				"SpawnGroupA":
					group_array.append(0)
				"SpawnGroupB":
					group_array.append(1)
				"SpawnGroupC":
					group_array.append(2)
	group_rand = randi_range(0,group_array.size()-1)
	group_num = group_array[group_rand]
#
func farway_spawn_comp_add() -> void:
	match local_wave:
		0:
			squad_comp.append(0)
			#squad_comp[0] = 0#Create Enemies
			#room_instantiate_enemy(0)
			#room_instantiate_enemy(1)
			#room_instantiate_enemy(2)
			#room_instantiate_enemy(3)
			#room_instantiate_enemy(4)
			#room_instantiate_enemy(5)
		1:
			squad_comp.append(0)
			squad_comp.append(0)
			squad_comp.append(1)
	
	#Spawn Enemies
	for spawn in get_tree().get_nodes_in_group("EnemySpawnPoint"):
		match spawn.name:
			spawn0:
				current_enemy0.global_position = spawn.global_position
			spawn1:
				current_enemy1.global_position = spawn.global_position
			spawn2:
				current_enemy2.global_position = spawn.global_position
			spawn3:
				current_enemy3.global_position = spawn.global_position
			spawn4:
				current_enemy4.global_position = spawn.global_position
			spawn5:
				current_enemy5.global_position = spawn.global_position
#
func room_instantiate_enemy(_spawnNum) -> void:
	match _spawnNum:
		0:
			current_enemy0 = enemy0.instantiate()
			add_child(current_enemy0)
			spawn0 = str(group_num,0)
			#pass
		1:
			current_enemy1 = enemy0.instantiate()
			add_child(current_enemy1)
			spawn1 = str(group_num,1)
			#pass
		2:
			current_enemy2 = enemy0.instantiate()
			add_child(current_enemy2)
			spawn2 = str(group_num,2)
			#pass
		3:
			current_enemy3 = enemy1.instantiate()
			add_child(current_enemy3)
			spawn3 = str(group_num,3)
		4: 
			current_enemy4 = enemy1.instantiate()
			add_child(current_enemy4)
			spawn4 = str(group_num,4)
		5:
			current_enemy5 = enemy2.instantiate()
			add_child(current_enemy5)
			spawn5 = str(group_num,5)
	enemy_count = get_tree().get_node_count_in_group("Enemy")
	print_debug(enemy_count)
#
func room_enemy_spawn_group() -> void:
	pass
#
func update_labels() -> void:
	wave_label.text = str(local_wave)
	if enemy_count > 0:
		enemy_label.text = str(enemy_count)
	else:
		enemy_label.text = str("")
#
func _on_inventory_gui_closed() -> void:
	get_tree().paused = false
#
func _on_inventory_gui_opened() -> void:
	get_tree().paused = true
