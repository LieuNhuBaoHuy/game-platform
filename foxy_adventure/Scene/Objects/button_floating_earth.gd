extends Area2D

# Kéo thả Node "KhoiDatDiDong" (AnimatableBody2D) vào ô này ở Inspector
@export var ground_block: AnimatableBody2D 

# Chiều cao muốn đất trồi lên (ví dụ: 64 pixel tương đương 2 ô Tile mặc định)
@export var move_distance: float = 64.0 

# Thời gian đất trồi lên (tính bằng giây)
@export var duration: float = 1.0 

@export var ButtonPress: Texture2D 

var is_triggered: bool = false

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not is_triggered:
		is_triggered = true
		var image = $Sprite2D
		if image:
			image.texture = ButtonPress
		print("Giẫm nút! Kích hoạt Tween...")
		
		# GỌI HÀM KÍCH HOẠT TWEEN
		start_ground_tween()

func start_ground_tween() -> void:
	if ground_block == null:
		print("Chưa gán KhoiDatDiDong vào Inspector!")
		return
		
	# 1. Tạo một Tween mới
	var tween = create_tween()
	
	# 2. Thiết lập hiệu ứng chuyển động (Cho nó mượt hơn)
	# .set_trans(Tween.TRANS_QUAD): Chuyển động theo đường cong (mượt hơn đường thẳng)
	# .set_ease(Tween.EASE_OUT): Chậm dần lại khi gần đến đích
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	# 3. Tính toán vị trí Y mới (Trục Y trong Godot đi lên là TRỪ)
	var target_y = ground_block.position.y - move_distance
	
	# 4. Chạy Tween: Thay đổi thuộc tính "position:y" của ground_block 
	# đến vị trí target_y trong vòng 'duration' giây
	tween.tween_property(ground_block, "position:y", target_y, duration)
	
	# 5. (Tùy chọn) Khi Tween chạy xong thì làm gì đó
	tween.tween_callback(func(): print("Đất đã trồi lên xong mượt mà!"))
