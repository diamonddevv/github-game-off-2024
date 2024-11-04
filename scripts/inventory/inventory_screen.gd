extends CanvasLayer
class_name InventoryScreen

signal closed()

var inventory: Inventory

@onready var capacity: Label = $MarginContainer/VBoxContainer/Label
@onready var cells: GridContainer = $MarginContainer/VBoxContainer/Cells


func _ready() -> void:
	_populate()
	
	inventory.updated.connect(_populate)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(&"open_player_inventory"):
		close()

func _populate() -> void:
	for c in cells.get_children():
		c.queue_free()
	
	capacity.text = "%s/%s" % [inventory.capacity, inventory.max_size]
	for item_name in inventory.items:
		cells.add_child(_make_cell(item_name, inventory.items[item_name]))

func _make_cell(nam: String, count: int) -> ColorRect:
	var rect: ColorRect = ColorRect.new()
	
	rect.color = Color.BLACK
	rect.custom_minimum_size = Vector2(50, 50)
	
	var n: Label = Label.new()
	var c: Label = Label.new()
	
	var center: CenterContainer = CenterContainer.new()
	center.custom_minimum_size = Vector2(50, 50)
	
	n.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	n.text = nam
	c.text = str(count)

	center.add_child(n)
	
	rect.add_child(center)
	rect.add_child(c)

	return rect

func close():
	closed.emit()
	self.queue_free()
