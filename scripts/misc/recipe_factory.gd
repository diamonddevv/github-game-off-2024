extends Node
class_name RecipeFactory 

func normal_factory(recipe: _GlobalManager.CraftRecipe, d: Dictionary) -> _GlobalManager.CraftRecipe:
	recipe.output.id = d["output"]["id"]
	recipe.output.count = (d["output"] as Dictionary).get("count", 1)
	
	for i: Dictionary in d["ingredients"]:
		var ing := _GlobalManager.ItemInstance.new()
		ing.id = i["id"]
		ing.count = i.get("count", 1)
		recipe.ingredients.append(ing)

	return recipe
	
	
func ore(recipe: _GlobalManager.CraftRecipe, d: Dictionary) -> _GlobalManager.CraftRecipe:
	var symbol: String = d["symbol"]
	
	recipe.output.id = "ingot_" + symbol
	recipe.output.count = d.get("metal_count", 1)
	
	var ing := _GlobalManager.ItemInstance.new()
	ing.id = "ore_" + symbol
	ing.count = d.get("ore_count", 3)
	
	recipe.ingredients.append(ing)
	
	return recipe
