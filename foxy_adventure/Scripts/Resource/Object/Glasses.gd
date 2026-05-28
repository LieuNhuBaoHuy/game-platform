extends Object_Data
class_name GlassesItem

@export var reveal_time : float = 5.0

func _use(player: BaseCharacter) -> void:
	var overlay = player.get_tree().get_first_node_in_group("secret_overlay")
	if overlay:
		# hiện + đổi màu
		overlay.modulate = Color(1,0.2,0.2,1)
		await player.get_tree().create_timer(reveal_time).timeout
		# ẩn lại
		overlay.modulate.a = 0
