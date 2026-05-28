class_name IdleState
extends FSMState

@onready var run_state: FSMState = $"../Run"
@onready var jump_state: FSMState = $"../Jump"
@onready var fall_state: FSMState = $"../Fall"

func _enter() -> void:
	obj.change_animation(States.idle)
	obj.stop_move()

func _update(_delta: float) -> void:
	if obj.is_dead:
		return
	var right := Input.get_action_strength(States.move_right)
	var left := Input.get_action_strength(States.move_left)
	var direction := int(right - left)
	# fall
	if not obj.is_on_floor():
		fsm.change_state(fall_state)
		return
	# jump
	if Input.is_action_just_pressed(States.jump):
		fsm.change_state(jump_state)
		return
	# run
	if direction != 0:
		fsm.change_state(run_state)
