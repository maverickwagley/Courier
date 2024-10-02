extends Node
#
var enemy0 = preload("res://Scenes/EnemyEntities/ent_skirmisher.tscn")
var enemy1 = preload("res://Scenes/EnemyEntities/ent_hunter.tscn")
var enemy2 = preload("res://Scenes/EnemyEntities/ent_gorog.tscn")
var enemy_list: Array
#enemy_list[0] = preload("res://Scenes/EnemyEntities/ent_skirmisher.tscn")


#
#Custom Methods
#
func detect_area_entered():
	pass
#
func hitbox_area_entered(area,particle,global_position):
		#if is_hurt == true: return
	if area.enemy_hit.find(self) == -1:
		area.enemy_hit.append(self)
		var _partChance = randi_range(0,1)
		if _partChance == 0:
			var current_part = particle.instantiate()
			for current_world in get_tree().get_nodes_in_group("World"):
				if current_world.name == "World":
					current_world.add_child(current_part) 
			current_part.particle.amount = randi_range(1,3)
			current_part.global_position = global_position
			current_part.global_rotation = area.global_rotation - PI
		return true
	else:
		return false
#
func farway_spawn_primary_0():
	pass
