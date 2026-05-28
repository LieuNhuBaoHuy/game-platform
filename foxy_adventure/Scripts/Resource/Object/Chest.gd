extends Node2D

@onready var area = $Area2D
@onready var anim = $Direction/AnimatedSprite2D
@onready var spawn_point = $SpawnPoint

@export var reward_scene : PackedScene

var opened = false

func _ready():
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player" and !opened:
		opened = true
		anim.play("open")
		spawn_reward()

func spawn_reward():
	if reward_scene:
		var item = reward_scene.instantiate()
		item.global_position = spawn_point.global_position
		get_tree().current_scene.add_child(item)
