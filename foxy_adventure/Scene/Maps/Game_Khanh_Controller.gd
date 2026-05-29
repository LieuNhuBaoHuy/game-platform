extends Node2D

class_name Game_Khanh_Controller
static var instance: Game_Khanh_Controller

@export var player_camera: Camera2D
@export var player_instance: BaseCharacter

func _ready() -> void:
	player_instance = get_parent().get_node("Player") as BaseCharacter
	
	_SetCamera()
	#_SetCameraLimit(327, -100, 517, 10000000000)

func _enter_tree() -> void:
	# Khi Map vừa được load, Controller này sẽ tự đăng ký nó làm "Giám đốc"
	if instance == null:
		instance = self
	else:
		push_warning("Cảnh báo: Có 2 thằng Controller trong cùng 1 Map!")

func _exit_tree() -> void:
	# QUAN TRỌNG: Khi chuyển sang Map khác, Map cũ bị xóa, 
	# Controller cũ cũng phải "từ chức" để nhường chỗ cho Controller của Map mới.
	if instance == self:
		instance = null
		
func _SetCamera() -> void:
	var camera = $"../Player/Camera2D" as Camera2D
	if camera:
		player_camera = camera
	
func _SetCameraLimit(left: int, top: int, bottom: int, right: int) -> void:
	if player_camera:
		player_camera.limit_left = left
		player_camera.limit_bottom = bottom 
		player_camera.limit_right = right
		player_camera.limit_top = top
