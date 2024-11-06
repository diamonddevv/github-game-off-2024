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
	
	for d in data:
		var item_type = ItemType.new()
		item_type.item_name = d["item_name"]
		item_type.item_texture_index = d["texture_idx"]
		
		item_types.append(item_type)
		
func load_recipes():
	recipes = []
	var data: Array = JSON.parse_string(FileAccess.open(recipes_json_path, FileAccess.READ).get_as_text())["recipes"]
	
	for d in data:
		var recipe := CraftRecipe.new()
		recipe.ingredients = []
		recipe.output = ItemInstance.new()
		
		recipe.output.idx = d["output"]["idx"]
		recipe.output.count = d["output"]["count"]
		
		for i in d["ingredients"]:
			var ing := ItemInstance.new()
			ing.idx = i["idx"]
			ing.count = i["count"]
			recipe.ingredients.append(ing)
	

static func get_texture_region_indexed(index: int, width: int, height: int, seperation: int, row: int) -> Rect2i:
	var x: int = (index % row)
	var y: int = roundi(index / row)

	x = width * x + seperation * (x - 1)
	y = height * y + seperation * (y - 1)

	return Rect2i(x, y, width, height)
	
class CraftRecipe:
	var ingredients: Array[ItemInstance]
	var output: ItemInstance
	
class ItemInstance:
	var idx: int
	var count: int
	
class ItemType:
	var item_name: String
	var item_texture_index: int
