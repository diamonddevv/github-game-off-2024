extends RigidBody2D
class_name Item

const ITEMS_ROW: int = 4
const ITEMS_W: int = 16
const ITEMS_H: int = 16
const ITEMS_SEP: int = 1

const USE_ACTION_NONE: String = "none";

@onready var sprite: Sprite2D = $Sprite

@export var item_idx: int = 0

var pickup_timer: float = 0

func _ready() -> void:
	_set_item()
	
func _process(delta: float) -> void:
	if pickup_timer > 0:
		pickup_timer -= delta


func _on_pickup_box_body_entered(body: Node2D):
	if body is Player:
		if pickup_timer <= 0:
			var actual_added = (body as Player).player_inventory.add_item(item_idx, 1)
			if actual_added == 0:
				return
			queue_free()

		
	
func _set_item() -> void:
	var data: _GlobalManager.ItemType = GlobalManager.item_types[item_idx]
	_set_item_texture(data.item_texture_index)

func _set_item_texture(index: int) -> void:
	sprite.texture = sprite.texture.duplicate()
	(sprite.texture as AtlasTexture).region = _GlobalManager.get_texture_region_indexed(index, ITEMS_W, ITEMS_H, ITEMS_SEP, ITEMS_ROW)
