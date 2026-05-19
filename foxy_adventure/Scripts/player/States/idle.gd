class_name IdleState
extends FSMState

@onready var run_state: FSMState = $"../run"
@onready var jump_state: FSMState = $"../jump"
@onready var fall_state: FSMState = $"../fall"

func _enter() -> void:
	obj.change_animation(States.idle)
	obj.stop_move()
func _update(_delta: float) -> void:
	var direction = Input.get_axis(States.move_left, States.move_right)
	if direction != 0:
		fsm.change_state(run_state)
	if Input.is_action_just_pressed(States.jump):
		fsm.change_state(jump_state)
	if not obj.is_on_floor():
		fsm.change_state(fall_state)
