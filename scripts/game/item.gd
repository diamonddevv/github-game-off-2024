extends Node2D
class_name Item

const ITEMS_ROW: int = 4
const ITEMS_W: int = 16
const ITEMS_H: int = 16
const ITEMS_SEP: int = 1

const items_json_path: String = "res://resources/item.json" 

@onready var sprite: Sprite2D = $Sprite

@export var item_idx: int = 0

var item_name: String = "Tin"
var item_count: int = 1

func _ready() -> void:
	_set_item()



func _on_pickup_box_body_entered(body: Node2D):
	if body is Player:
		(body as Player).player_inventory.add_item(item_name, item_count)
		queue_free()

		
	
func _set_item() -> void:
	var data: Dictionary = JSON.parse_string(FileAccess.open(items_json_path, FileAccess.READ).get_as_text())["items"][item_idx]
	
	item_name = data["item_name"]
	_set_item_texture(data["texture_idx"])

func _set_item_texture(index: int) -> void:
	
	sprite.texture = sprite.texture.duplicate()
	
	var x: int = (index % ITEMS_ROW)
	var y: int = roundi(index / ITEMS_ROW)

	x = ITEMS_W * x + ITEMS_SEP * (x - 1)
	y = ITEMS_H * y + ITEMS_SEP * (y - 1)

	(sprite.texture as AtlasTexture).region = Rect2i(x, y, ITEMS_W, ITEMS_H)
