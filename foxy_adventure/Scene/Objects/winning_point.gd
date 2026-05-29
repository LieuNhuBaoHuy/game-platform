extends Area2D

@export var WinningPanel: CanvasLayer

func _on_enter(body: Node2D) -> void:
	if body.name == "foxy_player":
		WinningPanel.show()
