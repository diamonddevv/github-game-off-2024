extends CanvasLayer
class_name RocketUi

signal ui_closed()

@onready var crafting: CraftingUi = $CraftingUi
@onready var inv: InventoryUi = $Inventory
@onready var planet_name: Label = $PlanetNameLabel

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
		
	planet_name.text = GlobalManager.planet_name
