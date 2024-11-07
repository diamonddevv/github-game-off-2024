extends MarginContainer
class_name CraftingUi

static var crafting_cell_prefab: PackedScene = ResourceLoader.load("res://prefabs/ui/crafting_cell.tscn")

@onready var crafting_vbox: VBoxContainer = $VBoxContainer

func _ready() -> void:
	_populate()

func _populate():
	for recipe in GlobalManager.recipes:
		var cell: CraftingCell = crafting_cell_prefab.instantiate()
		
		crafting_vbox.add_child(cell)
