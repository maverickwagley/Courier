extends Node2D

@export var player_scene: PackedScene
#@onready var form_control: CanvasLayer = $FormControl
@onready var tilemap = $TileMap

var enemy_count: int = 0
var enemy_spawn_timer: int = 0
var form_menu: bool = false

var enemy0 = preload("res://Scenes/EnemyEntities/ent_skirmisher.tscn")

func _ready():
	print_debug("Mode:" + str(ScrGameManager.mode))
	if ScrGameManager.mode == 1:
		var current_player = player_scene.instantiate()
		add_child(current_player)
		for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
			if spawn.name == str(0):
				current_player.global_position = spawn.global_position
				current_player.tilemap = tilemap
		pass
		
	if ScrGameManager.mode == 2:
		var index = 0
		for i in ScrGameManager.player:
			var current_player = player_scene.instantiate()
			current_player.name = str(ScrGameManager.player[i].id)
			add_child(current_player)
			for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
				if spawn.name == str(index):
					current_player.global_position = spawn.global_position
					current_player.tilemap = tilemap
			index = index + 1
		pass 

func _process(delta):
	farway_enemy_spawner()

func farway_enemy_spawner():
	if enemy_count < 10:
		if enemy_spawn_timer > 0:
			enemy_spawn_timer = enemy_spawn_timer - 1
		if enemy_spawn_timer <= 0:
			enemy_count = enemy_count + 1
			enemy_spawn_timer = 300
			var current_enemy = enemy0.instantiate()
			add_child(current_enemy)
			for spawn in get_tree().get_nodes_in_group("EnemySpawnPoint"):
					if spawn.name == str(0):
						current_enemy.global_position = spawn.global_position
						#current_enemy.is_aggro = true
						#current_enemy.aggro_timer = 300
						#var _trgt = get_tree().get_nodes_in_group("Player")
						#current_enemy.target_node = _trgt.owner

func _on_inventory_gui_closed():
	get_tree().paused = false

func _on_inventory_gui_opened():
	get_tree().paused = true
