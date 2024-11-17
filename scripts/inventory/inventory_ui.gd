extends MarginContainer
class_name InventoryUi

@onready var capacity: Label = $VBoxContainer/Label
@onready var cells: GridContainer = $VBoxContainer/Cells


var can_enter_rocket: bool
var can_use_this_item: bool
var inventory: Inventory
var selected_idx: int = -1
var inv_cells: Array[InventoryCell]



func _process(_delta: float) -> void:
	
	if len(inv_cells) > 0:
		inv_cells[clamp(selected_idx, 0, len(inv_cells) - 1)].selected = false
		
		if Input.is_action_just_pressed("inv_left"):
			selected_idx -= 1
		if Input.is_action_just_pressed("inv_right"):
			selected_idx += 1
			
		selected_idx = wrap(selected_idx, 0, len(inv_cells))
		
		inv_cells[selected_idx].selected = true

	capacity.text = "%s/%s | %s" % [inventory.capacity, inventory.max_size, _get_item_name()]

	if can_enter_rocket:
		capacity.text += " | Interact to Enter Rocket"
		
		
	can_use_this_item = get_can_use_item()
	if can_use_this_item:
		capacity.text += " | Can Use"

func _populate() -> void:
	inv_cells = []
	
	for c in cells.get_children():
		c.queue_free()
	
	for item_id in inventory.items.keys():
		var cell: InventoryCell = _make_cell(item_id, inventory.items[item_id])
		inv_cells.append(cell)
		cells.add_child(cell)
		
	if len(inv_cells) <= 0:
		selected_idx = -1

func _make_cell(item_id: String, count: int) -> InventoryCell:
	var cell: InventoryCell = Prefabs.inventory_cell.instantiate()
	
	cell.item_id = item_id
	cell.count_to_set = count

	return cell

func _get_item_name() -> String:
	if selected_idx < 0:
		return ""
	else:
		return GlobalManager.item_types[get_item_idx()].item_name

func get_item_idx() -> String:
	if selected_idx < 0:
		return ""
	else:
		return inv_cells[selected_idx].item_id


func get_can_use_item() -> bool:
	if selected_idx < 0:
		return false
	else:
		return GlobalManager.item_types[get_item_idx()].use_action != Item.USE_ACTION_NONE

		
func use_item() -> void:
	if can_use_this_item:
		ItemUseAction.call(
			GlobalManager.item_types[get_item_idx()].use_action,
			self, GlobalManager.item_types[get_item_idx()].use_data
		)
