class_name JumpState
extends FSMState

@onready var fall_state: FSMState = $"../fall"

func _enter() -> void:
	obj.change_animation(States.jump)
	obj.jump()
func _update(_delta: float) -> void:
	var direction = Input.get_axis(States.move_left, States.move_right)
	obj.velocity.x = direction * obj.movement_speed
	if direction < 0:
		obj.turn_left()
	if direction > 0:
		obj.turn_right()
	if obj.velocity.y > 0:
		fsm.change_state(fall_state)
