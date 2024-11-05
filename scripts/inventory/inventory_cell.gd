extends Control
class_name InventoryCell

@onready var texture_rect: TextureRect = $CenterContainer/Texture
@onready var label: Label = $Label


var texture_index_to_set: int
var count_to_set: int

func _ready() -> void:
	texture_rect.texture = texture_rect.texture.duplicate()
	(texture_rect.texture as AtlasTexture).region = GlobalManagerAutoloaded.get_texture_region_indexed(
		texture_index_to_set, Item.ITEMS_W, Item.ITEMS_H, Item.ITEMS_SEP, Item.ITEMS_ROW
	)
	label.text = str(count_to_set)
