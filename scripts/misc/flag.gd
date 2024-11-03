extends Node2D
class_name Flag

const FLAGS_ROW: int = 4
const FLAGS_W: int = 32
const FLAGS_H: int = 32
const FLAGS_SEP: int = 1

@onready var flag_bg: Sprite2D = $Mask/FlagBackground

func _ready() -> void:
	set_flag(7) # france

func set_flag(index: int) -> void:
	var x: int = 0
	var y: int = 0
	for i in index:
		if i == FLAGS_ROW - 1:
			y += FLAGS_H + FLAGS_SEP
			x = 0
			continue
		x += FLAGS_W + FLAGS_SEP
	
	(flag_bg.texture as AtlasTexture).region = Rect2i(x, y, FLAGS_W, FLAGS_H)
