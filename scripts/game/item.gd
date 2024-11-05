extends Node2D
class_name Item

const ITEMS_ROW: int = 4
const ITEMS_W: int = 16
const ITEMS_H: int = 16
const ITEMS_SEP: int = 1


@onready var sprite: Sprite2D = $Sprite

@export var item_idx: int = 0

func _ready() -> void:
	_set_item()



func _on_pickup_box_body_entered(body: Node2D):
	if body is Player:
		(body as Player).player_inventory.add_item(item_idx, 1)
		queue_free()

		
	
func _set_item() -> void:
	var data: GlobalManagerAutoloaded.ItemType = GlobalManager.item_types[item_idx]
	_set_item_texture(data.item_texture_index)

func _set_item_texture(index: int) -> void:
	sprite.texture = sprite.texture.duplicate()
	(sprite.texture as AtlasTexture).region = GlobalManagerAutoloaded.get_texture_region_indexed(index, ITEMS_W, ITEMS_H, ITEMS_SEP, ITEMS_ROW)
