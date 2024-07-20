extends Sprite2D

@onready var silhouette: Sprite2D = $SilhouetteSprite

func _ready() -> void:
	silhouette.texture = texture
	silhouette.offset = offset
	silhouette.flip_h = flip_h
	silhouette.hframes = hframes
	silhouette.vframes = vframes
	silhouette.frame = frame


func _set(property: StringName, value: Variant) -> bool:
	if is_instance_valid(silhouette):
		match property:
			"texture":
				silhouette.texture = value
			"offset":
				silhouette.offset = value
			"flip_h":
				silhouette.flip_h = value
			"hframes":
				silhouette.hframes = value
			"vframes":
				silhouette.vframes = value
			"frame":
				silhouette.frame = value
	return false
