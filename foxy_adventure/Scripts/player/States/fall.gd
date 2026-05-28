class_name FallState
extends FSMState

@onready var idle_state: FSMState = $"../Idle"
@onready var run_state: FSMState = $"../Run"
@onready var jump_state: FSMState = $"../Jump"

func _enter() -> void:
	obj.change_animation(States.fall)

func _update(_delta: float) -> void:
	var right := Input.get_action_strength(States.move_right)
	var left := Input.get_action_strength(States.move_left)
	var direction := int(right - left)
	if Input.is_action_just_pressed(States.jump):
		if obj.jump_count < obj.max_jumps:
			fsm.change_state(jump_state)
	if direction < 0:
		obj.turn_left()
	elif direction > 0:
		obj.turn_right()
	if obj.is_on_floor():
		if direction == 0:
			fsm.change_state(idle_state)
		else:
			fsm.change_state(run_state)
