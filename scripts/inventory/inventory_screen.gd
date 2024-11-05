extends CanvasLayer
class_name InventoryScreen

signal closed()

var inventory: Inventory

static var inv_cell_prefab: PackedScene = ResourceLoader.load("res://prefabs/ui/inventory_cell.tscn")

@onready var capacity: Label = $MarginContainer/VBoxContainer/Label
@onready var cells: GridContainer = $MarginContainer/VBoxContainer/Cells


func _ready() -> void:
	_populate()
	
	inventory.updated.connect(_populate)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(&"open_player_inventory"):
		close()

func _populate() -> void:
	for c in cells.get_children():
		c.queue_free()
	
	capacity.text = "%s/%s" % [inventory.capacity, inventory.max_size]
	for item_idx in inventory.items.keys():
		cells.add_child(_make_cell(item_idx, inventory.items[item_idx]))

func _make_cell(item_idx: int, count: int) -> InventoryCell:
	var cell: InventoryCell = inv_cell_prefab.instantiate()
	var type: GlobalManagerAutoloaded.ItemType = GlobalManager.item_types[item_idx]
	
	cell.texture_index_to_set = type.item_texture_index
	cell.count_to_set = count

	return cell

func close():
	closed.emit()
	self.queue_free()
