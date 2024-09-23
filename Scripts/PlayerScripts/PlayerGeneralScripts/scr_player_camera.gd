#Player Camera
#
extends Camera2D
#
@export var random_strength: float = 3.0
@export var shake_fade: float = 8.0
#
var is_shaking: bool = false
var rng = RandomNumberGenerator.new()
var tilemap: TileMapLayer
var shake_strength: float = 0.0
#
#Built-in Methods
#
func _process(delta) -> void:
	#update_camera_limit()
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength,0,shake_fade * delta)
		offset = random_offset()
	if shake_strength <= 0:
		is_shaking = false
#
#Custom Methods
#
func apply_shake(_strength) -> void:
	shake_strength = _strength

func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength,shake_strength),rng.randf_range(-shake_strength,shake_strength))
#
func update_camera(_tilemap) -> void:
	tilemap = _tilemap
	var map_rect = tilemap.get_used_rect()
	var tile_size = tilemap.rendering_quadrant_size
	var world_size_px = map_rect.size * tile_size
	limit_right = world_size_px.x
	limit_bottom = world_size_px.y - 80
