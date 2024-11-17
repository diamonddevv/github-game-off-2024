extends Node2D
class_name MainManager

signal world_ready()

@onready var canvas_modulate: CanvasModulate = $CanvasModulate

@export var rocks: int = 100


var rocks_list: Array[MineralRock]
var generator: WorldGenerator
var rocket: Rocket
var random: RandomNumberGenerator

func _ready() -> void:
	
	random = RandomNumberGenerator.new()
	random.set_seed(roundi(Time.get_unix_time_from_system())) 
	
	
	generator = Prefabs.world_generator.instantiate()
	get_tree().current_scene.add_child(generator)
	
	generator.done_generating.connect(post_generator.bind(generator))
	
	generator.generate(random)
	
	
	GlobalManager.planet_name = generate_planet_name(random)
	

func _process(_delta: float) -> void:
	canvas_modulate.color = EnvironmentManager.current.light_tint;
	
	if len(rocks_list) < rocks:
		add_rock(generator)


func post_generator(generator: WorldGenerator):
	# player
	var player: Player = Prefabs.player.instantiate()
	get_tree().current_scene.add_child(player)
	player.global_position = generator.snap_to_tilemap_top(Vector2.ZERO)
	
	# rocket
	rocket = Prefabs.rocket.instantiate()
	get_tree().current_scene.add_child(rocket)
	rocket.global_position = generator.snap_to_tilemap_top(Vector2(1000, 0))


func add_rock(generator: WorldGenerator):
	var rock: MineralRock = Prefabs.rock.instantiate()
	
	var pos: Vector2 = -Vector2.INF
	var dist: float = -1
	while pos == -Vector2.INF or dist < 1000 or rocket.global_position.distance_squared_to(pos) < 5000:
		dist = sqr_distance_to_nearest_rock(pos)
		pos = generator.random_snap_to_tilemap_top(random)
		if dist == -1:
			break
	rock.global_position = pos
	
	get_tree().current_scene.add_child(rock)
	rock.set_random_rock(random)
	rocks_list.append(rock)
	
	rock.on_destroyed.connect(rocks_list.erase.bind(rock))
	
	
func sqr_distance_to_nearest_rock(pos: Vector2) -> float:
	if len(rocks_list) == 0:
		return -1
	
	var closest: float = rocks_list[0].global_position.distance_squared_to(pos)
	for rock in rocks_list:
		var dist: float = rock.global_position.distance_squared_to(pos)
		if dist < closest:
			closest = dist
	return closest


func _rand_arr(arr: Array, random: RandomNumberGenerator) -> Variant:
	return arr[random.randi_range(0, len(arr) - 1)] 

func generate_planet_name(random: RandomNumberGenerator) -> String:
	
	var adjectives: Array[String] = [
		"Big", "Medium", "Little",
		"Hot", "Cold",
		"Red", "Orange", "Yellow", "Green", "Blue", "Indigo", "Violet",
		"Tera", "Giga", "Mega", "Kilo", "Milli", "Micro", "Nano", "Pico",
		"Galileo's", "Hubble's", "Newton's", "Ptolemy's", "Cassini's", "Kuiper's", "Hypatia's", "Fleming's",
		"Floating", "Twisting", "Orbiting",
		"Quirky", "Silly", "Funky", "Goofy", "Funny", "Buffalo",
		"Programmatical", "Coded", "Virtual", "Copyrighted", "Technological",
		"Electric", "Mechanical", "Motorised", "Natural", "Hydraulic", "Pneumatic", "Electronic",
		
		"Russian", "German", "Scottish", "English", "Welsh", "British", "French", "Italian", "Spanish", "Polish", 
		"Ukrainian", "Romanian", "Dutch", "Belgian", "Czech", "Swedish", "Portugese", "Greek", "Hungarian",
		"Austrian", "Swiss", "Belarusian", "Swiss", "Bulgarian", "Serbian", "Danish", "Finnish", "Norwegian",
		"Slovak", "Irish", "Croatian", "Bosnian", "Moldovan", "Lithuanian", "Albanian", "Slovene", "Latvian", "Macedonian",
		"Estonian", "Luxembourgish", "Montenegrin", "Maltese", "Icelandic", "Andorran", "Liechtensteinian", "Monégasque", "Sanmarinese", "Vatican",
		"Faeroese", "Ålandic", "Manx",
		
		"Mooned", "Ringed",
		"Adjective", "Not"
	]
	var nouns: Array[String] = [
		"Rock", "Mountain", "Valley", "Canyon", "Cape", "River", "Sea", "Ocean", "Volcano", "Peak", "Cliff",
		"Asteroid", "Dwarf", "Comet", "Satellite", "Moon", "Ring",
		"Place", "Location", "Point", "Area", "Zone",
		"City", "Town", "Province", "Country", "County", "Shire", "Island", "Township", "Burgh", "Village", "Hamlet",
		"Carrot", "Potato", "Leek", "Tomato", "Apple", "Banana", "Cherry", "Peapod", "Bean",
		"Cow", "Sheep", "Llama", "Giraffe", "Dog", "Cat", "Horse", "Bull", "Horse", "Buffalo",
		"Bell", "Telephone", "Car", "Truck", "Automobile", "Satellite", "Station", "Card", "Paper",
		"Fire", "Water", "Air",
		"Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune", "Pluto",
		
		"Hydrogen", "Helium",
		"Lithium", "Beryllium", "Boron", "Carbon", "Nitrogen", "Oxygen", "Flourine", "Neon",
		"Sodium", "Magnesium", "Aluminium", "Silicon", "Phosphorus", "Sulfur", "Chlorine", "Argon",
		"Potassium", "Calcium", "Scandium", "Titanium", "Vanadium", "Chromium", "Manganese", "Iron", "Cobalt", "Nickel", "Copper", "Zinc", "Gallium", "Germanium", "Arsenic", "Selenium", "Bromine", "Krypton",
		"Rubidium", "Strontium", "Yttrium", "Zirconium", "Niobium", "Molybdenum", "Technetium", "Ruthenium", "Rhodium", "Palladium", "Silver", "Cadmium", "Indium", "Tin", "Antimony", "Tellurium", "Iodine", "Xenon",
		"Caesium", "Barium", "Lanthanum", "Hafnium", "Tantalum", "Tungsten", "Rhenium", "Osmium", "Iridium", "Platinum", "Gold", "Mercury", "Thallium", "Lead", "Bismuth", "Polonium", "Astatine", "Radon",
		"Francium", "Radium", "Actinium", "Rutherfordium", "Dubnium", "Seaborgium", "Bohrium", "Hassium", "Meitnerium", "Darmstadtium", "Roentgenium", "Copernicium", "Nihonium", "Flerovium", "Moscovium", "Livermorium", "Tenessine", "Oganesson",
		"Cerium", "Praseodynium", "Neodynium", "Promethium", "Samarium", "Europium", "Gadolinium", "Terbium", "Dysprosium", "Holmium", "Erbium", "Thulium", "Ytterbium", "Lutetium", 
		"Thorium", "Protactinium", "Uranium", "Neptunium", "Plutonium", "Americium", "Curium", "Berkelium", "Californium", "Einsteinium", "Fermium", "Mendelevium", "Nobelim", "Lawrencium",
		
		"Noun", "Name"
	]
	
	var adjective: String = _rand_arr(adjectives, random)
	var noun: String = _rand_arr(nouns, random)
	
	return "Planet " + adjective + " " + noun
