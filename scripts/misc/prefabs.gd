extends Object
class_name Prefabs

# overlay
static var overlay: PackedScene = ResourceLoader.load("res://prefabs/ui/overlay.tscn")
static var crafting_cell: PackedScene = ResourceLoader.load("res://prefabs/ui/crafting_cell.tscn")
static var inventory_cell: PackedScene = ResourceLoader.load("res://prefabs/ui/inventory_cell.tscn")

# objects
static var item: PackedScene = ResourceLoader.load("res://prefabs/game/item.tscn")
static var rock: PackedScene = ResourceLoader.load("res://prefabs/game/mineral_rock.tscn")
static var player: PackedScene = ResourceLoader.load("res://prefabs/game/player.tscn")
static var world_generator: PackedScene = ResourceLoader.load("res://prefabs/world_generator.tscn")
static var rocket: PackedScene = ResourceLoader.load("res://prefabs/game/rocket.tscn")

# uis
static var rocket_ui: PackedScene = ResourceLoader.load("res://prefabs/ui/rocket_ui.tscn")
static var inv_ui: PackedScene = ResourceLoader.load("res://prefabs/ui/inventory.tscn")
static var crafting_ui: PackedScene = ResourceLoader.load("res://prefabs/ui/crafting_ui.tscn")
