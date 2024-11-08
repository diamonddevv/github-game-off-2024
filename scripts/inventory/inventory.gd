extends Node
class_name Inventory

signal updated()

@export var max_size: int = 32

var items: Dictionary
var capacity: int = 0
var screen_open: bool = false

func _ready() -> void:
	items = {}

	
func add_item(item_idx: int, count: int) -> int:
	
	if capacity >= max_size:
		return 0
	
	var added: int = 0
	if capacity + count <= max_size:
		added = count
	else:
		added = capacity - count
	
	if items.has(item_idx):
		items[item_idx] += added
	else:
		items[item_idx] = added
	
	capacity += added
	updated.emit()
	return added
	
func remove_item(item_idx: int, count: int) -> int:
	if items.has(item_idx):
		var act_removed: int = min(items[item_idx], count)
		
		items[item_idx] -= act_removed
		
		if items[item_idx] <= 0:
			items.erase(item_idx)
			
		updated.emit()
		
		capacity -= act_removed
		return act_removed
	else:
		return 0
