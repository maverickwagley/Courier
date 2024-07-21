extends Sprite2D

@onready var silhouette: Sprite2D = $Silhouette

func _ready() -> void:
	silhouette.texture = texture
	silhouette.offset = offset
	silhouette.flip_h = flip_h
	silhouette.flip_v = flip_v
	silhouette.hframes = hframes
	silhouette.vframes = vframes
	silhouette.frame_coords = frame_coords
	silhouette.frame = frame


func _set(property: StringName, value: Variant) -> bool:
	print_debug(property)
	if is_instance_valid(silhouette):
		match property:
			"texture":
				silhouette.texture = value
			"offset":
				silhouette.offset = value
			"flip_h":
				silhouette.flip_h = value
			"flip_v":
				silhouette.flip_v = value
			"hframes":
				silhouette.hframes = value
			"vframes":
				silhouette.vframes = value
			"frame":
				silhouette.frame = value
			"frame_coords":
				silhouette.frame_coords = value
	return false
