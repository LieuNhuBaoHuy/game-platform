extends Resource
class_name Object_Data

@export_group("General Info")
@export var IDObject: int 
@export var ObjectName: String
@export var ObjectImage: Texture2D
@export var ObjectDescription: String 
@export var CanBeUse: bool
@export var WillBeDelateAfterUse: bool = true


func _use(player: BaseCharacter) -> void:
	pass
