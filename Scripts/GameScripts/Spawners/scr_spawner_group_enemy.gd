#scr_spawner_enemy_group
#
extends Node2D
#
var collision_list: Array
#
#Signal Methods
#
func _on_spawn_area_entered(area: Area2D) -> void:
	if area.name == "Player":
		if collision_list.find(area) == -1:
			collision_list.append(area)


func _on_spawn_area_exited(area: Area2D) -> void:
	if area.name == "Player":
		collision_list.erase(area)
