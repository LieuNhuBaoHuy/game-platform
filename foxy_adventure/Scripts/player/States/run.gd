class_name RunState
extends FSMState

@onready var idle_state: FSMState = $"../idle"
@onready var jump_state: FSMState = $"../jump"
@onready var fall_state: FSMState = $"../fall"

func _enter() -> void:
	obj.change_animation(States.run)
func _update(_delta: float) -> void:
	var direction = Input.get_axis(States.move_left, States.move_right)
	if direction == 0:
		fsm.change_state(idle_state)
		return
	obj.velocity.x = direction * obj.movement_speed
	if direction < 0:
		obj.turn_left()
	if direction > 0:
		obj.turn_right()
	if Input.is_action_just_pressed(States.jump):
		fsm.change_state(jump_state)
	if not obj.is_on_floor():
		fsm.change_state(fall_state)
