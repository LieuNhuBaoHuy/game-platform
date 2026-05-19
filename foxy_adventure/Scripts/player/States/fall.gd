class_name FallState
extends FSMState

@onready var idle_state: FSMState = $"../Idle"
@onready var run_state: FSMState = $"../Run"

func _enter() -> void:
	obj.change_animation(States.fall)
func _update(_delta: float) -> void:
	var direction = Input.get_axis(States.move_left, States.move_right)
	obj.velocity.x = direction * obj.movement_speed
	if direction < 0:
		obj.turn_left()
	if direction > 0:
		obj.turn_right()
	if obj.is_on_floor():
		if direction == 0:
			fsm.change_state(idle_state)
		else:
			fsm.change_state(run_state)
