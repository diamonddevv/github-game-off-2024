extends Node
class_name _GlobalManager

const items_json_path: String = "res://resources/data/item.json"
const recipes_json_path: String = "res://resources/data/recipes.json"

var player: Player

var item_types: Array[ItemType]
var recipes: Array[CraftRecipe]

func _ready() -> void:
	load_item_types()
	load_recipes()

func load_item_types():
	item_types = []
	var data: Array = JSON.parse_string(FileAccess.open(items_json_path, FileAccess.READ).get_as_text())["items"]
	
	for d: Dictionary in data:
		var item_type = ItemType.new()
		item_type.item_name = d["item_name"]
		item_type.item_texture_index = d["texture_idx"]
		item_type.use_action = d.get("use_action", Item.USE_ACTION_NONE)
		
		item_types.append(item_type)
		
func load_recipes():
	recipes = []
	var data: Array = JSON.parse_string(FileAccess.open(recipes_json_path, FileAccess.READ).get_as_text())["recipes"]
	
	for d: Dictionary in data:
		var recipe := CraftRecipe.new()
		recipe.recipe_name = d["name"]
		recipe.ingredients = []
		recipe.output = ItemInstance.new()
		
		recipe.output.idx = d["output"]["idx"]
		recipe.output.count = (d["output"] as Dictionary).get("count", 1)
		
		for i: Dictionary in d["ingredients"]:
			var ing := ItemInstance.new()
			ing.idx = i["idx"]
			ing.count = i.get("count", 1)
			recipe.ingredients.append(ing)
			
		recipes.append(recipe)
		
	if OS.is_debug_build():
		for item: ItemType in item_types:
			var recipe := CraftRecipe.new()
			
			recipe.recipe_name = "DEBUG : %s" % item.item_name
			recipe.ingredients = []
			recipe.output = ItemInstance.new()
			recipe.output.idx = item_types.find(item)
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
	var idx: int
	var count: int
	
class ItemType:
	var item_name: String
	var item_texture_index: int
	var use_action: String
