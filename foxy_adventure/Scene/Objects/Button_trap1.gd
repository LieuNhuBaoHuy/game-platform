extends Area2D

@export var Spikes: RigidBody2D
@export var ButtonPress: Texture2D
var is_triggered: bool = false



func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not is_triggered:
		is_triggered = true
		var image = $Sprite2D
		if image:
			image.texture = ButtonPress
		Spikes.show()
		Spikes.set_deferred("freeze", false)
		Spikes.set_deferred("sleeping", false)
		print("Giẫm nút!")
