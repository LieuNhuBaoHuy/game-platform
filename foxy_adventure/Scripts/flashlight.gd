extends Node2D

@export var light_energy: float = 1.8
@export var light_scale: float = 1.0
@export var light_forward_offset: float = 200.0

@onready var light: PointLight2D = $PointLight2D

func _ready() -> void:
	light.energy = light_energy
	
	# Nếu muốn scale bằng Inspector của PointLight2D thì giữ comment dòng dưới
	# light.texture_scale = light_scale
	
	light.position = Vector2(light_forward_offset, 0)

func look_at_direction(direction: Vector2) -> void:
	if direction == Vector2.ZERO:
		return
	
	rotation = direction.angle()
