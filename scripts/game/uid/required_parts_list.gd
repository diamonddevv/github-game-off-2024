extends MarginContainer
class_name RequiredPartsList

@onready var cells: VBoxContainer = $VBoxContainer/VBoxContainer

static var parts_required: Array[_GlobalManager.ItemInstance] = [
	_GlobalManager.ItemInstance.create("ore_u", 1),
	_GlobalManager.ItemInstance.create("ingot_cu", 2),
	_GlobalManager.ItemInstance.create("ore_fe", 3),
	_GlobalManager.ItemInstance.create("ingot_au", 4)
]

func _ready():
	_populate()

func _populate():
	for c in cells.get_children():
		c.queue_free()
	
	for item: _GlobalManager.ItemInstance in parts_required:
		var cell: CraftingCell = Prefabs.crafting_cell.instantiate()
		
		var recipe := _GlobalManager.CraftRecipe.new()
		
		recipe.ingredients = []
		recipe.output = item
		
		cell.recipe = recipe

		cells.add_child(cell)
		cell._populate()
