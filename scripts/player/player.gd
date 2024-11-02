extends CharacterBody2D
class_name Player

@export var speed: float = 2.0
@export var jump_force: float = 5.0
@export var gravity: float = 10.0
@export var max_fall_speed: float = 10.0 
@export var max_jumps: int = 2
@export var jump_height_falloff: float = 0.75

@onready var sprite: AnimatedSprite2D = $Sprite

var _jumps_left: int           = 0
var _current_jump_force: float = 0
var _top_jump_force: float     = 0

func _physics_process(delta: float) -> void:
	_player_movement(delta)
	
	
func _player_movement(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * 100 * delta
		velocity.y = min(velocity.y, max_fall_speed * 100) # Cap fall speed
	else:
		_jumps_left = max_jumps

	# Handle horizontal movement
	var frame_direction: float = Input.get_axis("left", "right")
	velocity.x = frame_direction * speed * 100

	# Handle jumping
	var frame_jump_i: bool = Input.is_action_just_pressed("jump");
	var frame_jump: bool = Input.is_action_pressed("jump");
	var frame_jump_r: bool = Input.is_action_just_released("jump");
	
	
	if frame_jump_i and _jumps_left > 0:
		var falloff: float = (max_jumps - _jumps_left) / jump_height_falloff
		_top_jump_force = -jump_force * 100 / (falloff if falloff != 0 else 1.0)
		_current_jump_force = 0
	
	if frame_jump and _current_jump_force > _top_jump_force:
		velocity.y = _current_jump_force
		print(velocity.y)
		_current_jump_force = max(_top_jump_force, _current_jump_force - 2000 * delta)
		
	if frame_jump_r:
		_jumps_left -= 1

	move_and_slide()
	
	_player_visual(frame_direction, not is_on_floor())
	
	
func _player_visual(frame_direction: float, in_air: bool) -> void:
	if frame_direction != 0:
		sprite.flip_h = frame_direction < 0
		
		
	sprite.animation = &"idle" if frame_direction == 0 else &"walk"
	if in_air:
		sprite.animation = &"air"
	sprite.play()
