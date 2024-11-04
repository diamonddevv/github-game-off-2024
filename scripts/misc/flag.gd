extends Node2D
class_name Flag

const FLAGS_ROW: int = 4
const FLAGS_W: int = 32
const FLAGS_H: int = 32
const FLAGS_SEP: int = 1

@onready var flag_bg: Sprite2D = $Mask/FlagBackground

func _ready() -> void:
	set_flag(9)

func set_flag(index: int) -> void:
	var x: int = (index % FLAGS_ROW)
	var y: int = roundi(index / FLAGS_ROW)
	
	x = FLAGS_W * x + FLAGS_SEP * (x - 1)
	y = FLAGS_H * y + FLAGS_SEP * (y - 1)
	
	(flag_bg.texture as AtlasTexture).region = Rect2i(x, y, FLAGS_W, FLAGS_H)
