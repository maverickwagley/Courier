extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

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
			current_part.global_rotation = area.global_rotation - 3.14
		return true
	else:
		return false
