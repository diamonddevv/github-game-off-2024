extends CanvasLayer
class_name RocketUi

signal ui_closed()
signal ship_repaired()

@onready var crafting: CraftingUi = $CraftingUi
@onready var inv: InventoryUi = $Inventory
@onready var required_parts: RequiredPartsList = $RequiredPartsList
@onready var planet_name: Label = $PlanetNameLabel

var rocket: Rocket

static var ui_open: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	ui_open = true
	
	inv.inventory = GlobalManager.player.player_inventory
	
	crafting.inventory = inv.inventory
	crafting.inventory.updated.connect(func():
		for cell in crafting.cells:
			cell._inventory_updated()
			)
	
	crafting._populate()
	for cell in crafting.cells:
		cell._inventory_updated()

	inv.inventory.updated.connect(inv._populate)
	inv._populate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("interact"):
		ui_open = false
		ui_closed.emit()
		
	if needs_selected_item():
		if Input.is_action_just_pressed("use_item"):
			repair_ship()
		inv.other_label_texts.append(" | Can Use to Repair Ship")
		
	planet_name.text = GlobalManager.planet_name

func repair_ship():
	var item_id: String = inv.get_item_idx()
	for part in required_parts.parts_required:
		if part.id == item_id:
			part.count -= 1
			inv.inventory.remove_item(item_id, 1)
			if part.count <= 0:
				required_parts.parts_required.erase(part)
				if rocket:
					rocket.repair_level = clamp(rocket.repair_level + 1, 0, 3)
			break
			
	required_parts._populate()
	
	if required_parts.parts_required.size() <= 0:
		ship_repaired.emit()

func needs_selected_item() -> bool:
	if required_parts.parts_required.any(func (part: _GlobalManager.ItemInstance): 
		return part.id == inv.get_item_idx()
		):
			return true
	
	return false
