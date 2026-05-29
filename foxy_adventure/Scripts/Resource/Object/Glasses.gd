extends Object_Data
class_name GlassesItem


func _use(player: BaseCharacter) -> void:
	var overlay = player.get_tree().get_first_node_in_group("secret_overlay")
	if overlay:
		# hiện + đổi màu
		overlay.modulate = Color(1,0.2,0.2,1)
		WillBeDelateAfterUse = true
