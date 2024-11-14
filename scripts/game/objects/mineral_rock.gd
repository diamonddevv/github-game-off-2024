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
	"fe": Color.hex(0x8487ADFF),
	"au": Color.hex(0x8487ADFF),
	"li": Color.hex(0x8487ADFF),
	"ag": Color.hex(0xCAC9CFFF),
	"u":  Color.hex(0xACDAACFF)
}

var harvests_left: int = 0

func _ready() -> void:
	harvests_left = create_count
	sprite.material = (sprite.material as ShaderMaterial).duplicate()

func _process(_delta: float) -> void:
	for body in reachable_region.get_overlapping_bodies():
		if body is Player:

			if Input.is_action_just_pressed("interact"):
				_on_harvest()	

	(sprite.material as ShaderMaterial).set_shader_parameter(&"cracking", (
		float(harvests_left) / create_count
	))

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
	
