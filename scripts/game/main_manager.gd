extends Node2D
class_name MainManager

signal world_ready()

@onready var canvas_modulate: CanvasModulate = $CanvasModulate

@export var rocks: int = 100


var rocks_list: Array[MineralRock]
var generator: WorldGenerator
var random: RandomNumberGenerator

func _ready() -> void:
	
	random = RandomNumberGenerator.new()
	random.set_seed(roundi(Time.get_unix_time_from_system())) 
	
	
	generator = Prefabs.world_generator.instantiate()
	get_tree().current_scene.add_child(generator)
	
	generator.done_generating.connect(post_generator.bind(generator))
	
	generator.generate(random)
	
	

func _process(_delta: float) -> void:
	canvas_modulate.color = EnvironmentManager.current.light_tint;
	
	if len(rocks_list) < rocks:
		add_rock(generator)
		


func post_generator(generator: WorldGenerator):
	# rocks
	for i in rocks:
		add_rock(generator)
		
	# player
	var player: Player = Prefabs.player.instantiate()
	get_tree().current_scene.add_child(player)
	player.global_position = generator.snap_to_tilemap_top(Vector2.ZERO)
	
	# crafting station
	var c: CraftingStation = Prefabs.crafting_station.instantiate()
	get_tree().current_scene.add_child(c)
	c.global_position = generator.snap_to_tilemap_top(Vector2(1000, 0))


func add_rock(generator: WorldGenerator):
	var rock: MineralRock = Prefabs.rock.instantiate()
	rock.global_position = generator.random_snap_to_tilemap_top(random)
	get_tree().current_scene.add_child(rock)
	rock.set_random_rock(random)
	rocks_list.append(rock)
