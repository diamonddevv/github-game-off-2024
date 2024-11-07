extends Control
class_name InventoryCell

@onready var panel: Panel = $Panel
@onready var texture_rect: TextureRect = $Panel/CenterContainer/Texture
@onready var label: Label = $Panel/Label

var show_count: bool = true

var selected: bool
var item_idx: int
var count_to_set: int

func _ready() -> void:
	texture_rect.texture = texture_rect.texture.duplicate()
	panel.material = panel.material.duplicate()
	
	(texture_rect.texture as AtlasTexture).region = GlobalManager.get_texture_region_indexed(
		GlobalManager.item_types[item_idx].item_texture_index, Item.ITEMS_W, Item.ITEMS_H, Item.ITEMS_SEP, Item.ITEMS_ROW
	)
	label.text = str(count_to_set)


func _process(delta: float) -> void:
	label.visible = show_count
	(panel.material as ShaderMaterial).set_shader_parameter(&"enabled", selected)
	
