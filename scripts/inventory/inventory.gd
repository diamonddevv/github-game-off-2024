extends Node
class_name Inventory

static var inv_screen_prefab: PackedScene = ResourceLoader.load("res://prefabs/inventory_screen.tscn")

signal updated()

@export var max_size: int = 128

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

	
func add_item(p_name: String, count: int) -> void:
	capacity += count
	if items.has(p_name):
		items[p_name] += count
	else:
		items[p_name] = count
		
		updated.emit()
