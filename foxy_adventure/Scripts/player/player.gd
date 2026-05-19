extends BaseCharacter
func _ready() -> void:
	fsm.change_state($FSM/Idle)
