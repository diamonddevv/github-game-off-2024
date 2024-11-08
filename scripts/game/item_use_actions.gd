extends Node
class_name ItemUseActions

func none(overlay: Overlay):
	pass
	
	
func eat_sandwich(overlay: Overlay):
	overlay.inventory.remove_item(overlay.get_item_idx(), 1)

func test_acidity(overlay: Overlay):
	print("something about testing acidity")
	overlay.inventory.remove_item(overlay.get_item_idx(), 1)