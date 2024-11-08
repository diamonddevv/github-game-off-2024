extends MarginContainer
class_name CraftingUi



@onready var crafting_vbox: VBoxContainer = $VBoxContainer/VBoxContainer
@onready var crafting_label: Label = $VBoxContainer/Label


var selected_idx: int = 0
var cells: Array[CraftingCell]
var inventory: Inventory

func _ready() -> void:
	pass
	
	
func _process(_delta: float) -> void:
	
	if len(cells) > 0:
		cells[selected_idx].selected = false

		if Input.is_action_just_pressed("craft_nav_up"):
			selected_idx -= 1
		if Input.is_action_just_pressed("craft_nav_down"):
			selected_idx += 1

		selected_idx = wrap(selected_idx, 0, len(cells))

		cells[selected_idx].selected = true
		
		
		if Input.is_action_just_pressed("accept_craft"):
			if cells[selected_idx].can_craft():
				cells[selected_idx].accept_craft(GlobalManager.player)
		
	crafting_label.text = "%s | Crafting" % [cells[selected_idx].recipe.recipe_name]
	
	
	

func _populate():
	cells = []
	
	for c in crafting_vbox.get_children():
		c.queue_free()
	
	for recipe: _GlobalManager.CraftRecipe in GlobalManager.recipes:
		var cell: CraftingCell = Prefabs.crafting_cell.instantiate()
		
		cell.recipe = recipe
		cell.checked_inventory = inventory
		
		cells.append(cell)
		crafting_vbox.add_child(cell)
		
		cell._populate.call_deferred()
