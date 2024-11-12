
extends Node2D
class_name _WorldGenerator

@export var tileset: TileSet
@export var x_world_size: int = 512
@export var y_world_size: int = 64

var layer: TileMapLayer
var random: RandomNumberGenerator


var noise: FastNoiseLite

func _ready() -> void:
	scale = Vector2.ONE * 10 
	generate()
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("dbg_regen"):
		generate()

func generate():
	for c in get_children():
		c.queue_free()
	
	layer = TileMapLayer.new()
	layer.tile_set = tileset
	
	add_child(layer)

	random = RandomNumberGenerator.new()
	random.set_seed(roundi(Time.get_unix_time_from_system()))

	noise = FastNoiseLite.new()
	noise.seed = random.randi()
	
	for y in y_world_size:
		for x in x_world_size:
			var s: float = noise.get_noise_2d(x, y)
			if s < 0.25:
				set_tile(x - x_world_size / 2, y - y_world_size / 2)
				
	queue_redraw()
	
func _draw():
	for y in y_world_size:
		for x in x_world_size:
			var s: float = noise.get_noise_2d(x, y)
			draw_rect(Rect2i(x, y, 1, 1), Color(s, s, s, 1))
	
func set_tile(x: int, y: int):
	var coords := Vector2(x, y)
	layer.set_cell(coords, 0, Vector2.ONE)
	layer.set_cells_terrain_connect(layer.get_surrounding_cells(coords), 0, 1)
