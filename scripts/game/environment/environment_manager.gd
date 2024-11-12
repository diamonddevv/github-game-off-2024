extends Node
class_name _EnvironmentManager

var current: EnvironmentalEvents = EnvironmentalEvents.new()

func _ready() -> void:
	return
	current.gravity_modifier = randf_range(0.5, 2)
	current.light_tint = Color.hex(randi())
	current.light_tint.a = 1
	current.rain = randf() >= 0.5
	current.rain_toxicity = randf()
	
	

class EnvironmentalEvents:
	var gravity_modifier: float = 1
	var light_tint: Color = Color.WHITE
	var rain: bool = false
	var rain_toxicity: float = 0.0
