extends BaseCharacter

@export var push_force: float = 30.0 # Lực đẩy đá

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
	

func _update_movement(delta: float) -> void:
	# 1. Gọi super(delta) để BaseCharacter tính toán trọng lực và chạy move_and_slide()
	super(delta)
	
	# 2. KIỂM TRA ĐẨY ĐÁ (Chỉ thực hiện sau khi move_and_slide đã chạy)
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		# Nếu đụng trúng viên đá (RigidBody2D)
		if collider is RigidBody2D:
			var push_dir = -collision.get_normal()
			push_dir.y = 0 # Khóa trục Y để không đạp đá lún xuống đất
			
			# Tác dụng lực đẩy
			collider.apply_central_impulse(push_dir * push_force)
			
@export_file("*.tscn") var hub_scene : String
func die():
	GameManager.current_spawn_id = MapKey.hub
	get_tree().change_scene_to_file(hub_scene)
	
@export var max_jumps : int = 2
var jump_count : int = 0

func _physics_process(delta):
	super(delta)
	if is_on_floor():
		jump_count = 0
		
func jump():
	if jump_count >= max_jumps:
		return
	super()
	jump_count += 1
	
