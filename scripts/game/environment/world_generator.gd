extends Node2D
class_name WorldGenerator

signal done_generating()

@export var tileset: TileSet
@export var world_size: int = 512
@export var amplitude: float = 15
@export var enclosing_distance: int = 20

var layer: TileMapLayer

var noise: FastNoiseLite

var tilemap_top_elevations: Dictionary = {}

func _ready() -> void:
	scale = Vector2.ONE * 5 


func generate(random: RandomNumberGenerator):
	for c in get_children():
		if c is TileMapLayer:
			c.queue_free()
	
	layer = TileMapLayer.new()
	layer.tile_set = tileset
	
	add_child(layer)

	noise = FastNoiseLite.new()
	noise.seed = random.randi()
	
	var enclosing_weight: float = 0.5
	
	var low_enc: int = enclosing_distance
	var high_enc: int = world_size - enclosing_distance

	for x in world_size:
		var s: float = noise.get_noise_1d(x) + 1
		
		var dist_low = 	abs(x - low_enc)
		var dist_high = abs(x - high_enc)
		var mod: float = 0
		if dist_low < enclosing_distance:
			mod = min(abs(enclosing_distance - dist_low), enclosing_distance / 2) * enclosing_weight
		elif dist_high < enclosing_distance:
			mod = min(abs(enclosing_distance - dist_high), enclosing_distance / 2) * enclosing_weight
		
		s = max(s, s * mod)
	
		for y in (s * amplitude) + 10:
			set_tile(x - world_size / 2, -y)
			tilemap_top_elevations[x - world_size / 2] = -y
	
	done_generating.emit()
		
func set_tile(x: int, y: int):
	var coords := Vector2(x, y)
	layer.set_cell(coords, 0, Vector2.ONE)
	layer.set_cells_terrain_connect(layer.get_surrounding_cells(coords), 0, 1)

func snap_to_tilemap_top(pos: Vector2) -> Vector2:
	var vec2i: Vector2i = layer.local_to_map(layer.to_local(pos))
	var elev: int = tilemap_top_elevations.get(vec2i.x, vec2i.y) - 1
	return layer.to_global(layer.map_to_local(Vector2i(vec2i.x, elev)))
	
func random_snap_to_tilemap_top(random: RandomNumberGenerator) -> Vector2:
	var tteks = tilemap_top_elevations.keys()
	tteks.sort()
	var key: int = tteks[random.randi_range(enclosing_distance * 2, tteks.size() - 1 - enclosing_distance * 2)]
	return layer.to_global(layer.map_to_local(Vector2i(key, tilemap_top_elevations[key] - 1)))

func _on_kill_zone_body_entered(body: Node2D):
	if body is Player:
		(body as Player).die()
