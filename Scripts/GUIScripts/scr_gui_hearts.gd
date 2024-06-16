extends HBoxContainer

@onready var HeartContainerClass = preload("res://Scenes/GUIScenes/gui_heart_container.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_max_hearts(max: int):
	for i in range(max):
		var heart = HeartContainerClass.instantiate()
		add_child(heart)

func update_hearts(hp: int):
	var hearts = get_children()
	
	for i in range(hp):
		hearts[i].update(true)
		
	for i in range(hp, hearts.size()):
		hearts[i].update(false)
