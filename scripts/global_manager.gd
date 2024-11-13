extends Node
class_name _GlobalManager

const items_json_path: String = "res://resources/data/item.json"
const recipes_json_path: String = "res://resources/data/recipes.json"

var player: Player
var world_generator: _WorldGenerator

var item_types: Dictionary # string to ItemType
var recipes: Array[CraftRecipe]

func _ready() -> void:
	world_generator = get_tree().root.get_node("WorldGenerator");
	
	load_item_types()
	load_recipes()

func load_item_types():
	item_types = {}
	var data: Array = JSON.parse_string(FileAccess.open(items_json_path, FileAccess.READ).get_as_text())["items"]
	
	for d: Dictionary in data:
		var item_type = ItemType.new()
		item_type.item_name = d["item_name"]
		item_type.identifier = d.get("id", item_type.item_name.to_lower().replace(" ", "_"))
		item_type.atlas = d.get("atlas", "items")
		item_type.item_texture_index = d["texture_idx"]
		item_type.use_action = d.get("use_action", "none")
		item_type.use_data = d.get("use_data", {})
		
		item_types[item_type.identifier] = item_type
	
func load_recipes():
	recipes = []
	var data: Array = JSON.parse_string(FileAccess.open(recipes_json_path, FileAccess.READ).get_as_text())["recipes"]
	
	for d: Dictionary in data:
		var recipe := CraftRecipe.new()
		recipe.recipe_name = d["name"]
		recipe.ingredients = []
		recipe.output = ItemInstance.new()
		
		var factory: String = d.get("factory", "normal_factory")
		recipe = RecipeFactoryAL.call(factory, recipe, d)
		
		recipes.append(recipe)
		
	if OS.is_debug_build():
		for item_id: String in item_types:
			var item: ItemType = item_types[item_id]
			var recipe := CraftRecipe.new()
			
			recipe.recipe_name = "DEBUG : %s" % item_id
			recipe.ingredients = []
			recipe.output = ItemInstance.new()
			recipe.output.id = item_id
			recipe.output.count = 1
			
			recipes.append(recipe)
			

static func get_texture_region_indexed(index: int, width: int, height: int, seperation: int, row: int) -> Rect2i:
	var x: int = (index % row)
	var y: int = roundi(index / row)

	x = width * x + seperation * max(0, x - 1)
	y = height * y + seperation * max(0, y - 1)

	return Rect2i(x, y, width, height)

class CraftRecipe:
	var recipe_name: String
	var ingredients: Array[ItemInstance]
	var output: ItemInstance
	
class ItemInstance:
	var id: String
	var count: int

	func make_item() -> Item:
		var item: Item = Prefabs.item.instantiate()
		item.item_id = id

		return item

	
class ItemType:
	var item_name: String
	var identifier: String
	var atlas: String
	var item_texture_index: int
	var use_action: String
	var use_data: Dictionary
