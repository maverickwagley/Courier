extends Area2D

@export var item_resource: InventoryItem

func pick_up(inventory: Inventory):
	inventory.insert(item_resource)
	queue_free()
