extends Object_Data

class_name Buff_Object

enum BuffType { SPEED, PUSH, BLOOD }

@export_group("Value")
@export var value: float 
@export  var buff_type: BuffType



func _use(player: BaseCharacter) -> void:
	match buff_type:
		BuffType.SPEED:
			pass
		BuffType.PUSH:
			if (player):
				player.push_force += value
		BuffType.BLOOD:
			pass
	pass
