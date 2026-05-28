class_name DeadState
extends FSMState
var blink_timer := 0.0
var blink_speed := 0.1
func _enter() -> void:
	obj.velocity = Vector2.ZERO
	# tắt collision
	obj.get_node("CollisionShape2D").set_deferred("disabled", true)
	obj.set_collision_layer_value(1, false)
	obj.set_collision_mask_value(1, false)
	# animation chết
	obj.change_animation(States.dead)
func _update(delta: float) -> void:
	# gravity khi chết
	obj.velocity.y = 75
	obj.move_and_slide()
	blink_timer += delta
	if blink_timer >= blink_speed:
		blink_timer = 0
		if obj.animated_sprite.visible:
			obj.animated_sprite.visible = false
		else:
			obj.animated_sprite.visible = true
