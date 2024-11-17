extends CanvasLayer
class_name Overlay


@onready var invui: InventoryUi = $Inventory
@onready var health: TextureProgressBar = $Health


var preinit_inventory: Inventory

func _ready():
	invui.inventory = preinit_inventory
	invui.inventory.updated.connect(invui._populate)
	invui._populate()

func _process(_delta: float) -> void:
	
	health.max_value = GlobalManager.player.max_health
	health.value = GlobalManager.player.health
