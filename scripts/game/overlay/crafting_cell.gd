extends Control
class_name CraftingCell

@onready var panel: Panel = $Panel
@onready var crafted_item: TextureRect = $Panel/ResultItem
@onready var can_craft_indicator: TextureRect = $Panel/ResultItem/CanCraftTexture
@onready var crafted_count: Label = $Panel/ResultItem/Label
@onready var items: HBoxContainer = $Panel/HBoxContainer


const checkmark_region: Rect2i = Rect2i(17, 0, 16, 16)
const crossmark_region: Rect2i = Rect2i(0, 0, 16, 16)

var selected: bool = false
var recipe: _GlobalManager.CraftRecipe

var checked_inventory: Inventory

func _ready() -> void:
	panel.material = panel.material.duplicate()
	
	crafted_item.texture = crafted_item.texture.duplicate()
	can_craft_indicator.texture = can_craft_indicator.texture.duplicate()

	if recipe:
		crafted_item.texture.region = _GlobalManager.get_texture_region_indexed(
			GlobalManager.item_types[recipe.output.idx].item_texture_index,
			Item.ITEMS_W, Item.ITEMS_H, Item.ITEMS_SEP, Item.ITEMS_ROW
		)
		crafted_count.text = str(recipe.output.count)

	if checked_inventory:
		checked_inventory.updated.connect(_inventory_updated)
	

func _process(_delta: float) -> void:
	(panel.material as ShaderMaterial).set_shader_parameter(&"enabled", selected)
	
	
func _populate():
	for c in items.get_children():
		c.queue_free()

	for item: _GlobalManager.ItemInstance in recipe.ingredients:
		var cell: InventoryCell = Prefabs.inventory_cell.instantiate()

		cell.item_idx = GlobalManager.item_types[item.idx].item_texture_index
		cell.count_to_set = item.count

		items.add_child(cell)

func _inventory_updated():
	can_craft_indicator.texture.region = checkmark_region if can_craft() else crossmark_region
		
func can_craft() -> bool:
	for ing: _GlobalManager.ItemInstance in recipe.ingredients:
		if not checked_inventory.items.has(ing.idx):
			return false
		if checked_inventory.items[ing.idx] < ing.count:
			return false
	return true

func accept_craft(player: Player) -> void:
	for ing: _GlobalManager.ItemInstance in recipe.ingredients:
		checked_inventory.remove_item(ing.idx, ing.count)
	var act_added: int = checked_inventory.add_item(recipe.output.idx, recipe.output.count)
	
	var drop: int = recipe.output.count - act_added
	for i in drop:
		var item: Item = Prefabs.item.instantiate()
		item.item_idx = recipe.output.idx
		item.global_position = player.global_position
		get_tree().get_current_scene().add_child(item)
