extends BaseCharacter

@export var push_force: float = 30.0

# double jump
@export var max_jumps : int = 2
var jump_count : int = 0

# wall side
@export var wall_slide_speed : float = 60.0
@export var wall_jump_force_x : float = 250.0
@export var wall_jump_force_y : float = -400.0
var wall_jump_timer : float = 0.0
var is_wall_sliding : bool = false

@export_file("*.tscn") var hub_scene : String

func _ready() -> void:
	fsm = FSM.new(self, $States, $States/Idle)
	super()
	await get_tree().process_frame
	if GameManager.current_spawn_id == "":
		GameManager.current_spawn_id = MapKey.hub
	for spawn in get_tree().get_nodes_in_group(MapKey.point):
		if spawn.spawn_id == GameManager.current_spawn_id:
			global_position = spawn.global_position
			break

func _physics_process(delta):
	super(delta)
	if wall_jump_timer > 0:
		wall_jump_timer -= delta
	if is_on_floor():
		jump_count = 0
	handle_wall_slide()

func _update_movement(delta: float) -> void:
	# 1. Gọi super(delta) để BaseCharacter tính toán trọng lực và chạy move_and_slide()
	super(delta)

	# 2. KIỂM TRA ĐẨY ĐÁ (Chỉ thực hiện sau khi move_and_slide đã chạy)
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		# Nếu đụng trúng viên đá (RigidBody2D)
		if collider is RigidBody2D:
			var push_dir = -collision.get_normal()
			push_dir.y = 0 # Khóa trục Y để không đạp đá lún xuống đất
			# Tác dụng lực đẩy
			collider.apply_central_impulse(push_dir * push_force)

# wall side
func handle_wall_slide():
	is_wall_sliding = false
	# cooldown sau wall jump
	if wall_jump_timer > 0:
		return
	# đang trên không + chạm tường + đang rơi
	if not is_on_floor() and is_on_wall() and velocity.y > 0:
		is_wall_sliding = true
		jump_count = 1
		# giảm tốc độ rơi
		velocity.y = min(velocity.y, wall_slide_speed)

# jump
func jump():
	# chống spam wall jump
	if wall_jump_timer > 0:
		return
	# wall jump
	if is_wall_sliding:
		var wall_dir = get_wall_normal()
		velocity.x = wall_dir.x * wall_jump_force_x
		velocity.y = wall_jump_force_y
		wall_jump_timer = 0.2
		is_wall_sliding = false
		return
	# double jump
	if jump_count >= max_jumps:
		return
	super()
	jump_count += 1

func die():
	GameManager.current_spawn_id = MapKey.hub
	get_tree().change_scene_to_file(hub_scene)
