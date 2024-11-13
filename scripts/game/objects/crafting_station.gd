extends Node2D
class_name CraftingStation

@onready var reachable_region: Area2D = $ReachableRegion

func _ready():
	global_position = GlobalManager.world_generator.snap_to_tilemap_top(global_position)

func _process(_delta: float) -> void:
	for body in reachable_region.get_overlapping_bodies():
		if body is Player:
			var player := body as Player
			
			if Input.is_action_just_pressed("interact"):
				player.overlay.crafting_open = not player.overlay.crafting_open


func _on_reachable_region_body_exited(body: Node2D) -> void:
	if body is Player:
		var player := body as Player
		player.overlay.can_craft = false
		player.overlay.crafting_open = false


func _on_reachable_region_body_entered(body: Node2D) -> void:
	if body is Player:
		var player := body as Player
		player.overlay.can_craft = true
