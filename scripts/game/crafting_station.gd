extends Node2D
class_name CraftingStation


func _ready():
	pass


func _on_reachable_region_body_entered(body: Node2D) -> void:
	if body is Player:
		var player := body as Player
