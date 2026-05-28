extends CharacterBody2D

@export var speed : float = 50.0
@export var move_distance : float = 100.0
@onready var detect = $Area2D
@onready var anim = $Direction/AnimatedSprite2D
var direction = 1
var start_x : float

func _ready():
	anim.play("idle")
	start_x = global_position.x
	detect.body_entered.connect(_on_body_entered)
func _physics_process(delta):
	velocity.x = speed * direction
	move_and_slide()
	# đổi hướng
	if global_position.x > start_x + move_distance:
		direction = -1
		anim.flip_h = true
	elif global_position.x < start_x - move_distance:
		direction = 1
		anim.flip_h = false
func _on_body_entered(body):
	if body.name == "Player":
		print("Player Dead")
		body.die()
