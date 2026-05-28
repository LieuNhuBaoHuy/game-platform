extends CharacterBody2D

@export var speed : float = 50.0
@export var move_distance : float = 100.0
@export var gravity: float = 700.0
@onready var detect = $Area2D
@onready var anim = $Direction/AnimatedSprite2D
@export var direction: int = 1
var start_x : float

func _ready():
	anim.play("idle")
	anim.flip_h = direction == -1
	start_x = global_position.x
	detect.body_entered.connect(_on_body_entered)
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
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
		print(body.name)
		print("Player Dead")
		body.die()
