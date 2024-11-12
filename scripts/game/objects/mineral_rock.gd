extends Node2D
class_name MineralRock

signal harvested_from()
signal on_destroyed()

@onready var reachable_region: Area2D = $ReachableRegion

@export var item_id: String = "ore_cu"
@export var create_count: int

var harvests_left: int = 0

func _ready() -> void:
	harvests_left = create_count

func _process(_delta: float) -> void:
	for body in reachable_region.get_overlapping_bodies():
		if body is Player:

			if Input.is_action_just_pressed("interact"):
				_on_harvest()	

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
	
