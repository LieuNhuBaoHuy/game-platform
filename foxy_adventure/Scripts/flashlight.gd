extends Node2D

var _light: PointLight2D = null

func _ready() -> void:
	for child in get_children():
		if child is PointLight2D:
			_light = child
			break
	if _light == null:
		push_error("Flashlight2D: Không tìm thấy node con PointLight2D!")


func look_at_direction(direction: Vector2) -> void:
	if direction == Vector2.ZERO:
		return
	rotation = direction.angle()
