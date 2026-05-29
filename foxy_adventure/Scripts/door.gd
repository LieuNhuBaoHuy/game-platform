extends Area2D

@export_file("*.tscn") var next_scene_path: String
@export var target_spawn_id : String
var player_inside := false

func _ready():
	var animator = $AnimatedSprite2D
	if animator:
		animator.play("default")
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(delta):
	if player_inside and Input.is_action_just_pressed(ButtonKey.interact):
		print(next_scene_path)
		GameManager.current_spawn_id = target_spawn_id
		get_tree().change_scene_to_file(next_scene_path)

func _on_body_entered(body):
	if body.is_in_group(States.player):
		player_inside = true
		print("Press J to enter")

func _on_body_exited(body):
	if body.is_in_group(States.player):
		player_inside = false
