extends CanvasLayer
class_name Overlay

var inventory: Inventory
var selected_idx: int = -1
var inv_cells: Array[InventoryCell]

static var inv_cell_prefab: PackedScene = ResourceLoader.load("res://prefabs/ui/inventory_cell.tscn")

@onready var capacity: Label = $Inventory/VBoxContainer/Label
@onready var cells: GridContainer = $Inventory/VBoxContainer/Cells


func _ready() -> void:
	_populate()
	
	inventory.updated.connect(_populate)

func _process(_delta: float) -> void:
	
	if len(inv_cells) > 0:
		inv_cells[selected_idx].selected = false
		
		if Input.is_action_just_pressed("inv_left"):
			selected_idx -= 1
		if Input.is_action_just_pressed("inv_right"):
			selected_idx += 1
			
		selected_idx = wrap(selected_idx, 0, len(inv_cells))
		
		inv_cells[selected_idx].selected = true

	capacity.text = "%s/%s | %s" % [inventory.capacity, inventory.max_size, _get_item_name()]

func _populate() -> void:
	inv_cells = []
	
	
	for c in cells.get_children():
		c.queue_free()
	
	for item_idx in inventory.items.keys():
		var cell := _make_cell(item_idx, inventory.items[item_idx])
		inv_cells.append(cell)
		cells.add_child(cell)

func _make_cell(item_idx: int, count: int) -> InventoryCell:
	var cell: InventoryCell = inv_cell_prefab.instantiate()
	
	cell.item_idx = item_idx
	cell.count_to_set = count

	return cell

func _get_item_name() -> String:
	if selected_idx < 0:
		return ""
	else:
		return GlobalManager.item_types[inv_cells[selected_idx].item_idx].item_name
