#Room Farway
#
extends Node2D
#
@export var player_scene: PackedScene
@onready var tilemap: TileMapLayer = $TileMap/Base
#@onready var groupA: Node2D = $Markers/EnemySpawns/SpawnGroupA
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
func _physics_process(_delta):
	farway_enemy_spawner()
#
#Custom Methods
#
func farway_enemy_spawner():
	if enemy_count < 4:
		if enemy_spawn_timer > 0:
			enemy_spawn_timer = enemy_spawn_timer - 1
		if enemy_spawn_timer <= 0:
			enemy_count = enemy_count + 1
			enemy_spawn_timer = 600
			farway_wave_main()
#
func farway_wave_main():
	#Spawner Variables
	var _groupAry: Array
	var _groupNum: int = 0
	var _randGroup: int
	var _spawnDistance: float
	var _spawn0: String = "00"
	var _spawn1: String = "01"
	var _spawn2: String = "02"
	var _spawn3: String = "03"
	var _spawn4: String = "04"
	var _spawn5: String = "05"
	
	#Instantiate Enemies
	var _currentEnemy0 = enemy0.instantiate()
	var _currentEnemy1 = enemy0.instantiate()
	var _currentEnemy2 = enemy0.instantiate()
	var _currentEnemy3 = enemy1.instantiate()
	var _currentEnemy4 = enemy1.instantiate()
	var _currentEnemy5 = enemy2.instantiate()
	add_child(_currentEnemy0)
	add_child(_currentEnemy1)
	add_child(_currentEnemy2)
	add_child(_currentEnemy3)
	add_child(_currentEnemy4)
	add_child(_currentEnemy5)
	
	#Spawner Selection
	for group in get_tree().get_nodes_in_group("EnemySpawnGroup"):
		if group.collision_list.size() <= 0:
			match group.name:
				"SpawnGroupA":
					_groupAry.append(0)
				"SpawnGroupB":
					_groupAry.append(1)
				"SpawnGroupC":
					_groupAry.append(2)
	_randGroup = randi_range(0,_groupAry.size()-1)
	_groupNum = _groupAry[_randGroup]
	print_debug(_groupNum)
	_spawn0 = str(_groupNum,0)
	_spawn1 = str(_groupNum,1)
	_spawn2 = str(_groupNum,2)
	_spawn3 = str(_groupNum,3)
	_spawn4 = str(_groupNum,4)
	_spawn5 = str(_groupNum,5)
	
	#Spawn Enemies
	for spawn in get_tree().get_nodes_in_group("EnemySpawnPoint"):
		match spawn.name:
			_spawn0:
				_currentEnemy0.global_position = spawn.global_position
			_spawn1:
				_currentEnemy1.global_position = spawn.global_position
			_spawn2:
				_currentEnemy2.global_position = spawn.global_position
			_spawn3:
				_currentEnemy3.global_position = spawn.global_position
			_spawn4:
				_currentEnemy4.global_position = spawn.global_position
			_spawn5:
				_currentEnemy5.global_position = spawn.global_position
#
func room_enemy_spawn_group():
	pass
#
func _on_inventory_gui_closed():
	get_tree().paused = false
#
func _on_inventory_gui_opened():
	get_tree().paused = true
