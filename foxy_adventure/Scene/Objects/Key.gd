extends Area2D

var is_player_in_range: bool = false
@export var data: Object_Data
func _on_enter(player: Node2D) -> void:
	if player.name == "Player":
		is_player_in_range = true
		# Bạn có thể hiện một cái UI nhỏ hiển thị chữ "Bấm E để nhặt" ở đây
		print("Đã vào vùng, bấm nút để tương tác!")

# BẮT BUỘC: Bạn cần nối thêm signal body_exited (khi Player đi ra khỏi vùng)
func _on_exit(player: Node2D) -> void:
	if player.name == "Player":
		is_player_in_range = false
		print("Đã rời vùng tương tác.")

# Hàm này chạy liên tục mỗi khung hình để bắt sự kiện nhấn nút
func _process(delta: float) -> void:
	# Nếu Player đang đứng trong vùng VÀ bấm nút tương tác (Ví dụ phím "ui_accept" hoặc nút tự tạo "interact")
	if is_player_in_range and Input.is_action_just_pressed("interact"):
		collect_item()

func collect_item() -> void:
	print("Đã thu thập vật phẩm thành công!")
	# Viết logic cộng điểm, thêm vào kho đồ (Inventory) của bạn ở đây...
	InventorySystem.AddInventory(data)
	# Xóa vật thể này khỏi màn hình sau khi nhặt
	queue_free()
