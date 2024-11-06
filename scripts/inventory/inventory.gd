extends Node
class_name Inventory

static var inv_screen_prefab: PackedScene = ResourceLoader.load("res://prefabs/ui/inventory_screen.tscn")

signal updated()

@export var max_size: int = 32

var items: Dictionary
var capacity: int = 0
var screen_open: bool = false

func _ready() -> void:
	items = {}
	
func open_inventory_screen() -> void:
	var screen: InventoryScreen = inv_screen_prefab.instantiate()
	screen.inventory = self
	get_tree().get_current_scene().add_child(screen)
	
	screen_open = true
	await screen.closed
	screen_open = false

	
func add_item(item_idx: int, count: int) -> int:
	
	if capacity >= max_size:
		return 0
	
	var added: int = 0
	if capacity + count <= max_size:
		added = count
	else:
		added = max_size - capacity
	
	if items.has(item_idx):
		items[item_idx] += count
	else:
		items[item_idx] = count
	
	capacity += added
	updated.emit()
	return added
	
