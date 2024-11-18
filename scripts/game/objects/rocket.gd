extends Node2D
class_name Rocket

@onready var reachable_region: Area2D = $ReachableRegion
@onready var sprite: Sprite2D = $Sprite2D

var repair_level: int = 0

func _ready():
	sprite.texture = sprite.texture.duplicate()

func _process(_delta: float) -> void:
	(sprite.texture as AtlasTexture).region = GlobalManager.get_texture_region_indexed(
		repair_level, 32, 32, 1, 2
	)
	
	for body in reachable_region.get_overlapping_bodies():
		if body is Player:
			var player := body as Player
			
			if Input.is_action_just_pressed("interact") and not RocketUi.ui_open:
				var ui: RocketUi = Prefabs.rocket_ui.instantiate()
				ui.rocket = self
				get_tree().current_scene.add_child(ui)
				
				await ui.ui_closed
				ui.queue_free()


func _on_reachable_region_body_exited(body: Node2D) -> void:
	if body is Player:
		var player := body as Player
		player.overlay.invui.can_enter_rocket = false


func _on_reachable_region_body_entered(body: Node2D) -> void:
	if body is Player:
		var player := body as Player
		player.overlay.invui.can_enter_rocket = true
