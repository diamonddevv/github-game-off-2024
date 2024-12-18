extends CharacterBody2D
class_name Player

const IDLE_ANIM := &"idle"
const WALK_ANIM := &"walk"
const FALL_ANIM := &"fall"
const JUMP_ANIM := &"jump"
const CROUCH_ANIM := &"crouch"

signal on_die()

@export var speed: float = 2.0
@export var jump_force: float = 6.0
@export var gravity: float = 10.0
@export var max_fall_speed: float = 10.0 
@export var max_jumps: int = 2
@export var jump_height_falloff: float = 0.9
@export var max_health: float = 100
@export var inv_size: int = 32

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var jump_particle: CPUParticles2D = $Sprite/JumpParticle
@onready var land_particle: CPUParticles2D = $Sprite/LandParticle
@onready var run_particle: CPUParticles2D  = $Sprite/RunParticle

@onready var player_inventory: Inventory = $Inventory

var overlay: Overlay
var health: float

var _jumps_left: int = 0
var _last_on_ground: bool = false
var _last_direction: float = 0
var _crouching: bool = false

func _ready() -> void:
	GlobalManager.player = self
	
	overlay = Prefabs.overlay.instantiate()
	get_tree().get_current_scene().add_child.call_deferred(overlay)
	overlay.preinit_inventory = player_inventory
	
	health = max_health
	
	

func _physics_process(delta: float) -> void:
	if not RocketUi.ui_open:
		_player_movement(delta)
	
	$CollisionShape2D.shape.size = Vector2(40, 30 if _crouching else 40)
	$CollisionShape2D.position = Vector2(0, 15 if _crouching else 10)
	
	_last_on_ground = is_on_floor()
	
func _process(_delta: float) -> void:
	overlay.invui.inventory.max_size = inv_size
	
	var item_id: String = overlay.invui.get_item_idx()
	
	if Input.is_action_just_pressed("throw_item") and item_id != "":
		
		var item: Item = Prefabs.item.instantiate()
		item.item_id = item_id
		item.pickup_timer = 0.1
		
		get_tree().get_current_scene().add_child(item)
		
		item.global_position = global_position
		
		if not _crouching:
			item.apply_central_force(Vector2(1 * _last_direction, -1) * 35_000)
		
		player_inventory.remove_item(item_id, 1)
		
	if Input.is_action_just_pressed("use_item") and not RocketUi.ui_open:
		overlay.use_item()
		
	if health <= 0:
		on_die.emit()
		die()
	
func get_grav() -> float:
	if velocity.y > 0:
		return gravity * EnvironmentManager.current.gravity_modifier
	return gravity * 1.4 * EnvironmentManager.current.gravity_modifier
	
	
func die() -> void:
	print("player died lol what a loser")
	get_tree().quit()

func _player_movement(delta: float) -> void:
	# gravity
	if not is_on_floor():
		velocity.y += get_grav() * 100 * delta
		velocity.y = min(velocity.y, max_fall_speed * 100) # terminal velocity
	else:
		_jumps_left = max_jumps
	
	# crouch
	_crouching = Input.is_action_pressed("crouch")
	if _crouching:
		move_and_slide()
		_player_visual(_last_direction, not is_on_floor())
		velocity.x = move_toward(velocity.x, 0, delta * (600 if is_on_floor() else 200))
		return


	# horizontal
	var frame_direction: float = Input.get_axis("left", "right")
	velocity.x = frame_direction * speed * 100

	# jumping
	var frame_jump_i: bool = Input.is_action_just_pressed("jump");
	var frame_jump_r: bool = Input.is_action_just_released("jump");
	
	if frame_jump_i and _jumps_left > 0:
		var falloff: float = (max_jumps - _jumps_left) / jump_height_falloff
		velocity.y = -jump_force * 100 / (falloff if falloff != 0 else 1.0)
		jump_particle.emitting = true
		_jumps_left -= 1
	
	if frame_jump_r and velocity.y < 0: # if falling
		velocity.y = -jump_force * 100 / 4

	move_and_slide()
	
	_last_direction = frame_direction
	
	if is_on_floor() and not _last_on_ground:
		land_particle.emitting = true
	
	_player_visual(frame_direction, not is_on_floor())
	
func _player_visual(frame_direction: float, in_air: bool) -> void:
	if frame_direction != 0:
		sprite.flip_h = frame_direction < 0
		run_particle.position.x = 3.6 if frame_direction < 0 else -3.6

	sprite.animation = IDLE_ANIM if frame_direction == 0 else WALK_ANIM
	if in_air:
		sprite.animation = JUMP_ANIM if velocity.y < 0 else FALL_ANIM
		
	if _crouching:
		sprite.animation = CROUCH_ANIM

	if sprite.animation != IDLE_ANIM:
		sprite.speed_scale = velocity.length_squared() / (speed * 100) ** 2
	else:
		sprite.speed_scale = 1
		
	run_particle.emitting = not in_air
	run_particle.amount = roundi(64 * inverse_lerp(0, (speed * 100) ** 2, velocity.length_squared())) + 1
	

	sprite.play()
