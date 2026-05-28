extends Area2D
class_name Items
@export var item_data: Object_Data

func _ready():
	connect("body_entered", _on_body_entered)
	if item_data:
		$Sprite2D.texture = item_data.ObjectImage

func _on_body_entered(body):
	if body.is_in_group(States.player):
		sfx.play("res://Assets/audio/sfx/collect/coin.mp3", 2.0)
		InventorySystem.AddInventory(item_data)
		queue_free()
