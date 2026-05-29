extends CharacterBody2D

# ==============================================================================
# PLAYER SCRIPT — all-in-one
# ==============================================================================

enum PlayerState {
	IDLE,
	RUN,
	JUMP,
	FALL,
	DEFEAT,
}

# ------------------------------------------------------------------------------
@export_category("Movement")
@export var movement_speed: float   = 180.0
@export var acceleration: float     = 2000.0
@export var friction: float         = 2200.0
@export var air_acceleration: float = 1400.0
@export var air_friction: float     = 400.0
@export var jump_velocity: float    = -420.0
@export var gravity: float          = 980.0
@export var max_fall_speed: float   = 1200.0
@export var max_jumps: int          = 2

# ------------------------------------------------------------------------------
@export_category("Push RigidBody2D")
@export var push_force: float = 30.0

# ------------------------------------------------------------------------------
@export_category("Input Actions")
@export var move_left_action: StringName  = &"move_left"
@export var move_right_action: StringName = &"move_right"
@export var jump_action: StringName       = &"jump"

# ------------------------------------------------------------------------------
@export_category("Animation Names")
@export var idle_animation:   StringName = &"idle"
@export var run_animation:    StringName = &"run"
@export var jump_animation:   StringName = &"jump"
@export var fall_animation:   StringName = &"fall"
@export var defeat_animation: StringName = &"defeat"

# ------------------------------------------------------------------------------
@export_category("Spike Detection")
## Tên chính xác (name) của node TileMapLayer gai trong scene tree.
@export var spike_layer_name: String = "spike"

# ------------------------------------------------------------------------------
@export_category("Spawn / Respawn")
## Thời gian nằm chờ sau khi chết trước khi hồi sinh (giây).
@export var defeat_wait_time: float = 1.0
## Tắt → player hồi sinh đúng tại vị trí đặt trong Editor (đơn giản nhất).
## Bật → tìm spawn point theo group + spawn_id.
@export var use_spawn_point_group: bool = false
@export var spawn_group: StringName = &"point"
@export var target_spawn_id: String = "start"

# ------------------------------------------------------------------------------
@export_category("Node Paths")
@export var visual_path: NodePath           = ^"AnimatedSprite2D"
@export var animation_player_path: NodePath = ^"AnimationPlayer"
@export var flip_visual_with_scale: bool    = false

# ------------------------------------------------------------------------------
@export_category("Sound Effects")
@export_file("*.mp3", "*.wav", "*.ogg") var jump_sfx_path: String = ""
@export var jump_sfx_volume_db: float = 0.0

# ==============================================================================
# INTERNAL STATE
# ==============================================================================
var state: int            = -1
var jump_count: int       = 0
var facing_direction: int = 1
var _spawn_position: Vector2
var last_direction := Vector2.RIGHT

@onready var visual_node:      Node2D           = get_node_or_null(visual_path) as Node2D
@onready var animated_sprite:  AnimatedSprite2D = get_node_or_null(visual_path) as AnimatedSprite2D
@onready var sprite_2d:        Sprite2D         = get_node_or_null(visual_path) as Sprite2D
@onready var animation_player: AnimationPlayer  = get_node_or_null(animation_player_path) as AnimationPlayer

# Flashlight — lấy bằng get_node_or_null để không crash nếu chưa có
@onready var _flashlight: Node2D = get_node_or_null(^"Flashlight2D")

# ==============================================================================
func _ready() -> void:
	_refresh_spawn_position()
	change_state(PlayerState.IDLE)


# ==============================================================================
func _physics_process(delta: float) -> void:
	if state == PlayerState.DEFEAT:
		velocity = Vector2.ZERO
		move_and_slide()
		_sync_flashlight()
		return

	var direction    := get_input_direction()
	var jump_pressed := Input.is_action_just_pressed(jump_action)

	_apply_gravity(delta)

	if is_on_floor():
		jump_count = 0

	# Cập nhật hướng nhìn cho flashlight
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_dir != Vector2.ZERO:
		last_direction = input_dir.normalized()

	match state:
		PlayerState.IDLE:  _update_idle(delta, direction, jump_pressed)
		PlayerState.RUN:   _update_run(delta, direction, jump_pressed)
		PlayerState.JUMP:  _update_jump(delta, direction, jump_pressed)
		PlayerState.FALL:  _update_fall(delta, direction, jump_pressed)

	move_and_slide()
	_push_rigid_bodies()
	_check_spike_collision()
	_update_state_after_move(direction)

	# Sync flashlight SAU move_and_slide để position luôn đúng
	_sync_flashlight()


# Đặt flashlight đúng vị trí player trong global space, tránh mọi vấn đề flip/scale
func _sync_flashlight() -> void:
	if _flashlight == null:
		return
	_flashlight.global_position = global_position
	if _flashlight.has_method("look_at_direction"):
		_flashlight.look_at_direction(last_direction)


# ==============================================================================
# INPUT
# ==============================================================================
func get_input_direction() -> int:
	return int(Input.get_action_strength(move_right_action) - Input.get_action_strength(move_left_action))


# ==============================================================================
# PHYSICS HELPERS
# ==============================================================================
func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y = min(velocity.y + gravity * delta, max_fall_speed)
	elif velocity.y > 0.0:
		velocity.y = 0.0


func move(delta: float, direction: int, in_air: bool = false) -> void:
	var target_speed := float(direction) * movement_speed
	if in_air:
		if direction != 0:
			velocity.x = move_toward(velocity.x, target_speed, air_acceleration * delta)
		else:
			velocity.x = move_toward(velocity.x, 0.0, air_friction * delta)
	else:
		if direction != 0:
			velocity.x = move_toward(velocity.x, target_speed, acceleration * delta)
		else:
			velocity.x = move_toward(velocity.x, 0.0, friction * delta)


func stop_move(delta: float = 0.0) -> void:
	velocity.x = move_toward(velocity.x, 0.0, friction * delta if delta > 0.0 else 1e9)


func try_jump() -> void:
	if jump_count >= max_jumps:
		return
	velocity.y = jump_velocity
	jump_count += 1
	if jump_sfx_path != "":
		SFX_loop.play(jump_sfx_path, jump_sfx_volume_db)
	change_state(PlayerState.JUMP)


# ==============================================================================
# STATE UPDATES
# ==============================================================================
func _update_idle(delta: float, direction: int, jump_pressed: bool) -> void:
	stop_move(delta)
	if not is_on_floor():
		change_state(PlayerState.FALL); return
	if jump_pressed:
		try_jump(); return
	if direction != 0:
		change_state(PlayerState.RUN); return


func _update_run(delta: float, direction: int, jump_pressed: bool) -> void:
	if direction < 0: turn_left()
	elif direction > 0: turn_right()
	move(delta, direction, false)
	if jump_pressed:
		try_jump(); return
	if not is_on_floor():
		change_state(PlayerState.FALL); return
	if direction == 0:
		change_state(PlayerState.IDLE); return


func _update_jump(delta: float, direction: int, jump_pressed: bool) -> void:
	if direction < 0: turn_left()
	elif direction > 0: turn_right()
	move(delta, direction, true)
	if jump_pressed:
		try_jump(); return
	if velocity.y > 0.0:
		change_state(PlayerState.FALL); return


func _update_fall(delta: float, direction: int, jump_pressed: bool) -> void:
	if direction < 0: turn_left()
	elif direction > 0: turn_right()
	move(delta, direction, true)
	if jump_pressed:
		try_jump(); return
	if is_on_floor():
		change_state(PlayerState.IDLE if direction == 0 else PlayerState.RUN)


func _update_state_after_move(direction: int) -> void:
	if state == PlayerState.DEFEAT:
		return
	if is_on_floor():
		if state == PlayerState.FALL or state == PlayerState.JUMP:
			change_state(PlayerState.IDLE if direction == 0 else PlayerState.RUN)
	else:
		if state == PlayerState.IDLE or state == PlayerState.RUN:
			change_state(PlayerState.FALL)


# ==============================================================================
# STATE MACHINE
# ==============================================================================
func change_state(new_state: int) -> void:
	if state == new_state:
		return
	state = new_state
	match state:
		PlayerState.IDLE:
			change_animation(idle_animation)
			stop_move()
		PlayerState.RUN:
			change_animation(run_animation)
		PlayerState.JUMP:
			change_animation(jump_animation)
		PlayerState.FALL:
			change_animation(fall_animation)
		PlayerState.DEFEAT:
			velocity = Vector2.ZERO
			change_animation(defeat_animation)
			_handle_defeat_sequence.call_deferred()


func change_animation(anim_name: StringName) -> void:
	if animated_sprite != null and animated_sprite.sprite_frames != null:
		if animated_sprite.sprite_frames.has_animation(anim_name):
			if animated_sprite.animation != anim_name:
				animated_sprite.play(anim_name)
			return
	if animation_player != null and animation_player.has_animation(String(anim_name)):
		if animation_player.current_animation != String(anim_name):
			animation_player.play(String(anim_name))


# ==============================================================================
# FACING
# ==============================================================================
func turn_left()  -> void: _set_facing(-1)
func turn_right() -> void: _set_facing(1)

func _set_facing(direction: int) -> void:
	if direction == 0 or state == PlayerState.DEFEAT:
		return
	facing_direction = direction
	if animated_sprite != null:
		animated_sprite.flip_h = facing_direction < 0
	elif sprite_2d != null:
		sprite_2d.flip_h = facing_direction < 0
	elif flip_visual_with_scale and visual_node != null:
		var s := visual_node.scale
		s.x = abs(s.x) * float(facing_direction)
		visual_node.scale = s
	# Flashlight KHÔNG đặt ở đây — _sync_flashlight() lo phần đó mỗi frame


# ==============================================================================
# PUSH RIGID BODIES
# ==============================================================================
func _push_rigid_bodies() -> void:
	for i in range(get_slide_collision_count()):
		var col      := get_slide_collision(i)
		var collider := col.get_collider()
		if collider is RigidBody2D:
			var push_dir := -col.get_normal()
			push_dir.y = 0.0
			if push_dir != Vector2.ZERO:
				collider.apply_central_impulse(push_dir.normalized() * push_force)


# ==============================================================================
# SPIKE DETECTION
# ==============================================================================
func _check_spike_collision() -> void:
	if state == PlayerState.DEFEAT:
		return
	for i in range(get_slide_collision_count()):
		var col      := get_slide_collision(i)
		var collider := col.get_collider()
		if collider != null and collider.name == spike_layer_name:
			change_state(PlayerState.DEFEAT)
			break


# ==============================================================================
# DEFEAT / RESPAWN
# ==============================================================================
func _handle_defeat_sequence() -> void:
	await get_tree().create_timer(defeat_wait_time).timeout

	if not is_inside_tree():
		return

	global_position = _spawn_position
	jump_count      = 0
	velocity        = Vector2.ZERO
	state           = PlayerState.FALL  # Tránh guard "if state == new_state"
	change_state(PlayerState.IDLE)


# ==============================================================================
# SPAWN POSITION
# ==============================================================================

## Gọi từ checkpoint: player hồi sinh tại đây từ bây giờ.
func set_spawn_here() -> void:
	_spawn_position = global_position


## Gọi từ checkpoint phức tạp hơn: cập nhật id + vị trí cùng lúc.
func update_spawn(new_spawn_id: String, new_position: Vector2) -> void:
	target_spawn_id = new_spawn_id
	_spawn_position = new_position


func _refresh_spawn_position() -> void:
	if use_spawn_point_group:
		for spawn in get_tree().get_nodes_in_group(spawn_group):
			if str(spawn.get("spawn_id")) == target_spawn_id:
				_spawn_position = spawn.global_position
				return
		push_warning(
			"Player: Không tìm thấy spawn_id='%s' trong group='%s'. Dùng vị trí hiện tại." \
			% [target_spawn_id, spawn_group]
		)
	_spawn_position = global_position
