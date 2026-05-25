extends BaseCharacter

@export var push_force: float = 30.0 # Lực đẩy đá

func _ready() -> void:
	fsm = FSM.new(self, $States, $States/Idle)
	super()
	

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
