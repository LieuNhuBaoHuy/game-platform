extends Area2D

@onready var secret_wall = $"../TileMapLayer2"

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Player":
		secret_wall.visible = false

func _on_body_exited(body):
	if body.name == "Player":
		secret_wall.visible = true
