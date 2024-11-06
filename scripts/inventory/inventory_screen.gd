extends CanvasLayer
class_name InventoryScreen

signal closed()

var inventory: Inventory
var selected_idx: int = 0
var inv_cells: Array[InventoryCell]

static var inv_cell_prefab: PackedScene = ResourceLoader.load("res://prefabs/ui/inventory_cell.tscn")

@onready var capacity: Label = $MarginContainer/VBoxContainer/Label
@onready var cells: GridContainer = $MarginContainer/VBoxContainer/Cells


func _ready() -> void:
	_populate()
	
	inventory.updated.connect(_populate)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(&"open_player_inventory"):
		close()
	
	
	if len(inv_cells) > 0:
		inv_cells[selected_idx].selected = false
		
		if Input.is_action_just_pressed("inv_left"):
			selected_idx -= 1
		if Input.is_action_just_pressed("inv_right"):
			selected_idx += 1
			
		selected_idx = wrap(selected_idx, 0, len(inv_cells))
		
		inv_cells[selected_idx].selected = true

func _populate() -> void:
	inv_cells = []
	for c in cells.get_children():
		c.queue_free()
	
	capacity.text = "%s/%s" % [inventory.capacity, inventory.max_size]
	for item_idx in inventory.items.keys():
		var cell := _make_cell(item_idx, inventory.items[item_idx])
		inv_cells.append(cell)
		cells.add_child(cell)

func _make_cell(item_idx: int, count: int) -> InventoryCell:
	var cell: InventoryCell = inv_cell_prefab.instantiate()
	var type: GlobalManagerAutoloaded.ItemType = GlobalManager.item_types[item_idx]
	
	cell.texture_index_to_set = type.item_texture_index
	cell.count_to_set = count

	return cell

func close():
	closed.emit()
	self.queue_free()
