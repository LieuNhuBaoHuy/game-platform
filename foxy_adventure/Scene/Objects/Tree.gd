extends Node2D

@export var coconut: RigidBody2D
var haveSpawnCoconut: bool = false
func _on_body_entered(body: Node2D):
	if body.name == "Player":
		if body.has_method("get_real_velocity") or "velocity" in body:
			if body.velocity.y >= 0:
				print ("Thả trái dừa")
				drop_coconut()

func drop_coconut() -> void:
	if coconut:
		if haveSpawnCoconut:
			print ("Trái dừa được thả rồi")
			return
		print ("Thả trái dừa lần đầu")
		haveSpawnCoconut = true
		coconut.show()
		
		# Thay vì coconut.freeze = false, hãy dùng dòng này:
		coconut.set_deferred("freeze", false)
		coconut.set_deferred("sleeping", false)
		
		# Gọi hàm đẩy lực ở khung hình tiếp theo
		Callable(func(): 
			if is_instance_valid(coconut):
				coconut.apply_central_impulse(Vector2(randf_range(-30, 30), 10))
		).call_deferred()
