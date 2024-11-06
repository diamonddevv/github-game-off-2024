extends Control
class_name InventoryCell

@onready var texture_rect: TextureRect = $CenterContainer/Texture
@onready var label: Label = $Label

var selected: bool
var item_idx: int
var count_to_set: int

func _ready() -> void:
	texture_rect.texture = texture_rect.texture.duplicate()
	texture_rect.material = texture_rect.material.duplicate()
	
	(texture_rect.texture as AtlasTexture).region = GlobalManager.get_texture_region_indexed(
		GlobalManager.item_types[item_idx].item_texture_index, Item.ITEMS_W, Item.ITEMS_H, Item.ITEMS_SEP, Item.ITEMS_ROW
	)
	label.text = str(count_to_set)


func _process(delta: float) -> void:
	(texture_rect.material as ShaderMaterial).set_shader_parameter(&"enabled", selected)
	
