extends RigidBody2D

func _ready() -> void:
	self.hide()
	self.freeze = true
	
func on_enter_body(body: Node2D)-> void:
	if body.name == "Player":
		print ("Trúng Player.")
		body.die()
