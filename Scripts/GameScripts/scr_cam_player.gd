extends Camera2D

@export var tilemap: TileMap
# Called when the node enters the scene tree for the first time.
func _ready():
	update_camera_room()

func update_camera_room():
	var map_rect = tilemap.get_used_rect()
	var tile_size = tilemap.cell_quadrant_size
	var world_size_pixels = map_rect.size * tile_size
	limit_left = 0;
	limit_right = world_size_pixels.x
	limit_top = 0;
	limit_bottom = world_size_pixels.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
