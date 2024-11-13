extends Node2D
class_name MainManager

@onready var canvas_modulate: CanvasModulate = $CanvasModulate
#@onready var rain: ShaderMaterial = $RainOverlay.material

@export var rocks: int = 100

func _ready() -> void:
	for i in rocks:
		var rock: MineralRock = Prefabs.rock.instantiate()
		rock.global_position = GlobalManager.world_generator.random_snap_to_tilemap_top()
		get_tree().current_scene.add_child(rock)
	
		rock.set_random_rock(GlobalManager.world_generator.random)

func _process(_delta: float) -> void:
	canvas_modulate.color = EnvironmentManager.current.light_tint;
	#rain.set_shader_parameter("enabled", EnvironmentManager.current.rain)
