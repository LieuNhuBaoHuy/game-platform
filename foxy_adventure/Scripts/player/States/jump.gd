class_name JumpState
extends FSMState

@onready var fall_state: FSMState = $"../Fall"

func _enter() -> void:
	obj.change_animation(States.jump)
	obj.jump()

func _update(_delta: float) -> void:
	if obj.is_dead:
		return
	var right := Input.get_action_strength(States.move_right)
	var left := Input.get_action_strength(States.move_left)
	var direction := int(right - left)
	if direction < 0:
		obj.turn_left()
	elif direction > 0:
		obj.turn_right()
	if obj.velocity.y > 0:
		fsm.change_state(fall_state)
	obj.velocity.x = direction * obj.movement_speed
