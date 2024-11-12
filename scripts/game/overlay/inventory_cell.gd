extends Control
class_name InventoryCell

@onready var panel: Panel = $Panel
@onready var texture_rect: TextureRect = $Panel/CenterContainer/Texture
@onready var label: Label = $Panel/Label

var show_count: bool = true

var selected: bool
var item_id: String
var count_to_set: int

func _ready() -> void:
	panel.material = panel.material.duplicate()
	
	if item_id:
		texture_rect.texture = Item.get_atlased_item(GlobalManager.item_types[item_id])
		label.text = str(count_to_set)


func _process(delta: float) -> void:
	label.visible = show_count
	(panel.material as ShaderMaterial).set_shader_parameter(&"enabled", selected)
	
