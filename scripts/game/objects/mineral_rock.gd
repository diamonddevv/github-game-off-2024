extends Node2D
class_name MineralRock

signal harvested_from()
signal on_destroyed()

@onready var reachable_region: Area2D = $ReachableRegion
@onready var sprite: Sprite2D = $Sprite2D

@export var item_id: String = "ore_cu"
@export var create_count: int

static var mineral_symbols: Dictionary = {
	"cu": Color.hex(0xB88A5BFF), 
	"ti": Color.hex(0x8487ADFF), 
	"fe": Color.hex(0xCBC5C3FF),
	"au": Color.hex(0xD4C773FF),
	"li": Color.hex(0x753636FF),
	"ag": Color.hex(0xCAC9CFFF),
	"u":  Color.hex(0xACDAACFF)
}

var harvests_left: int = 0

func _ready() -> void:
	harvests_left = create_count
	sprite.texture = sprite.texture.duplicate()

func _process(_delta: float) -> void:
	for body in reachable_region.get_overlapping_bodies():
		if body is Player:

			if Input.is_action_just_pressed("interact"):
				_on_harvest()	
				
				
	var progress: float = float(harvests_left) / create_count
	var index: int
	if progress > 0.8:
		index = 0
	elif progress > 0.6:
		index = 1
	elif progress > 0.4:
		index = 2
	else:
		index = 3
		
	(sprite.texture as AtlasTexture).region = _GlobalManager.get_texture_region_indexed(
		index, 32, 32, 1, 2
	)


func set_random_rock(random: RandomNumberGenerator):
	var key: String = mineral_symbols.keys()[random.randi_range(0, mineral_symbols.keys().size() - 1)]
	item_id = "ore_" + key
	create_count = random.randi_range(5, 16)
	harvests_left = create_count
	sprite.self_modulate = mineral_symbols[key]
	

func _on_harvest():
	harvested_from.emit()
	var item: Item = Prefabs.item.instantiate()
	item.item_id = item_id
	item.global_position = global_position
	get_tree().get_current_scene().add_child(item)
	item.apply_impulse(Vector2(_randf2() * 200, _randf2() * 200), Vector2(randi_range(-24, 24), randi_range(-24, 24)))

	harvests_left -= 1
	
	if harvests_left <= 0:
		on_destroyed.emit()
		queue_free()
	
	
func _randf2() -> float:
	return 2 * randf() - 1
	
