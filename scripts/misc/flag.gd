extends Node2D
class_name Flag

const FLAGS_ROW: int = 4
const FLAGS_W: int = 32
const FLAGS_H: int = 32
const FLAGS_SEP: int = 1

@onready var flag_bg: Sprite2D = $Mask/FlagBackground

func _ready() -> void:
	set_flag(5)

func set_flag(index: int) -> void:
	flag_bg.texture = flag_bg.texture.duplicate()
	
	(flag_bg.texture as AtlasTexture).region = _GlobalManager.get_texture_region_indexed(
		index, FLAGS_W, FLAGS_H, FLAGS_SEP, FLAGS_ROW
	)
