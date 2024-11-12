extends Node
class_name ItemUseActions

func none(_overlay: Overlay):
	pass
	
	
func eat_food(overlay: Overlay, data: Dictionary):
	print("healed %s" % data.get("heal", 20))
	overlay.inventory.remove_item(overlay.get_item_idx(), 1)

func test_acidity(overlay: Overlay, data: Dictionary):
	print("something about testing acidity")
	overlay.inventory.remove_item(overlay.get_item_idx(), 1)