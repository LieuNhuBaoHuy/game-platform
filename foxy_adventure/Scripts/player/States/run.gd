class_name RunState
extends FSMState

@onready var idle_state: FSMState = $"../Idle"
@onready var jump_state: FSMState = $"../Jump"
@onready var fall_state: FSMState = $"../Fall"

func _enter() -> void:
	obj.change_animation(States.run)
	
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
	# movement
	obj.move()
	# jump
	if Input.is_action_just_pressed(States.jump):
		fsm.change_state(jump_state)
		return
	# idle
	if direction == 0:
		fsm.change_state(idle_state)
		return
	# fall
	if not obj.is_on_floor():
		fsm.change_state(fall_state)
		return
