extends Node2D

@onready var area = $Area2D
@onready var anim = $Direction/AnimatedSprite2D
@onready var spawn_point = $SpawnPoint

@export var reward_scene : PackedScene

var opened = false

func _ready():
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player" and !opened:
		opened = true
		anim.play("open")
		spawn_reward()

func spawn_reward():
	if reward_scene:
		var item = reward_scene.instantiate()
		item.global_position = spawn_point.global_position
		get_tree().current_scene.add_child(item)
		
		# Kiểm tra chắc chắn item là RigidBody2D để tránh crash code
		if item is RigidBody2D:
			# Tạo một Vector lực đẩy: 
			# Trục X: Ngẫu nhiên từ -50 đến 50 để item văng nhẹ sang trái hoặc phải cho tự nhiên
			# Trục Y: Lực âm (khoảng -200 đến -300) để bắn ngược LÊN TRÊN
			var push_force = Vector2(randf_range(-50, 50), randf_range(-250, -300))
			
			# Áp dụng lực đẩy ngay lập tức (Impulse) vào tâm của vật thể
			item.apply_central_impulse(push_force)
