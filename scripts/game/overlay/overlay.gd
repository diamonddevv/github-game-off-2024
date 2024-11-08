extends CanvasLayer
class_name Overlay

var inventory: Inventory
var selected_idx: int = -1
var inv_cells: Array[InventoryCell]
var can_craft: bool
var crafting_open: bool
var can_use_this_item: bool


@onready var capacity: Label = $Inventory/VBoxContainer/Label
@onready var cells: GridContainer = $Inventory/VBoxContainer/Cells
@onready var health: TextureProgressBar = $Health

@onready var crafting_root: CraftingUi = $Crafting

func _ready() -> void:
	_populate()
	
	inventory.updated.connect(_populate)
	
	crafting_root.inventory = inventory
	crafting_root._populate()

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
	
	if can_craft and not crafting_open:
		capacity.text += " | Interact to Craft"
		
		
	can_use_this_item = get_can_use_item()
	if can_use_this_item:
		capacity.text += " | Can Use"
	
	crafting_root.visible = crafting_open

	health.max_value = GlobalManager.player.max_health
	health.value = GlobalManager.player.health

func _populate() -> void:
	inv_cells = []
	
	for c in cells.get_children():
		c.queue_free()
	
	for item_idx in inventory.items.keys():
		var cell: InventoryCell = _make_cell(item_idx, inventory.items[item_idx])
		inv_cells.append(cell)
		cells.add_child(cell)
		
	if len(inv_cells) <= 0:
		selected_idx = -1

func _make_cell(item_idx: int, count: int) -> InventoryCell:
	var cell: InventoryCell = Prefabs.inventory_cell.instantiate()
	
	cell.item_idx = item_idx
	cell.count_to_set = count

	return cell

func _get_item_name() -> String:
	if selected_idx < 0:
		return ""
	else:
		return GlobalManager.item_types[get_item_idx()].item_name

func get_item_idx() -> int:
	if selected_idx < 0:
		return -1
	else:
		return inv_cells[selected_idx].item_idx


func get_can_use_item() -> bool:
	if selected_idx < 0:
		return false
	else:
		return GlobalManager.item_types[get_item_idx()].use_action != Item.USE_ACTION_NONE

		
func use_item() -> void:
	if can_use_this_item:
		ItemUseAction.call(
			GlobalManager.item_types[get_item_idx()].use_action,
			self
		)
