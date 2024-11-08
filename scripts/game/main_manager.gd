extends Node2D
class_name MainManager

@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var rain: ShaderMaterial = $RainOverlay.material

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	canvas_modulate.color = EnvironmentManager.current.light_tint;
	rain.set_shader_parameter("enabled", EnvironmentManager.current.rain)
