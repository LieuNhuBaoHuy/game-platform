extends StaticBody2D

var is_player_in_range: bool = false

# SỬA Ở ĐÂY: Đổi từ RigidBody2D thành PackedScene để kéo file item (.tscn) vào được
@export var ItemInside: PackedScene 
@export var CheseOpen: Texture2D 

# Biến để kiểm tra rương đã mở chưa, tránh việc người chơi bấm E liên tục để spawn item
var is_opened: bool = false

func _on_enter(player: Node2D) -> void:
	if player.name == "Player":
		is_player_in_range = true
		print("Đã vào vùng, bấm nút để tương tác!")

func _on_exit(player: Node2D) -> void:
	if player.name == "Player":
		is_player_in_range = false
		print("Đã rời vùng tương tác.")
		
func _process(delta: float) -> void:
	# Thêm điều kiện "and not is_opened" để chỉ cho mở rương 1 lần
	if is_player_in_range and Input.is_action_just_pressed("interact") and not is_opened:
		if !InventorySystem.CheckObjectInInventory(KeyData.Key):
			print("Không có chìa khóa")
			return
			
		var child = $Sprite2D
		if child and CheseOpen:
			child.texture = CheseOpen
		
		is_opened = true # Đánh dấu rương đã mở
		create_item()

func create_item() -> void:
	# 1. Kiểm tra xem bạn đã kéo file vật phẩm vào ô Inspector chưa
	if ItemInside == null:
		print("Chưa gán ItemInside trong Inspector!")
		return
		
	# 2. Tạo ra một bản sao (Instance) của vật phẩm từ file tscn
	var item_instance = ItemInside.instantiate() as RigidBody2D
	
	# 3. Đặt vị trí xuất hiện của vật phẩm ngay tại vị trí của cái rương
	item_instance.global_position = global_position
	
	# 4. Thêm vật phẩm vào Scene chính (nên thêm vào cha của cái rương hoặc Node chính của màn chơi)
	get_parent().add_child(item_instance)
	
	# 5. Tạo lực văng (Impulse)
	# Vector2(X, Y): X ngẫu nhiên từ -100 đến 100 (văng trái/phải), Y từ -200 đến -300 (văng lên trên)
	var launch_velocity = Vector2(randf_range(-100, 100), randf_range(-250, -350))
	
	# 6. Kích hoạt lực đẩy để vật phẩm văng ra ngoài
	item_instance.apply_central_impulse(launch_velocity)
	print("Item đã văng ra!")
