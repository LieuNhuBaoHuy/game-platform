extends Area2D

@export_file("*.tscn") var next_scene_path: String
@export var target_spawn_id : String
@export var DoorID: int = 0
@export var Notification: CanvasLayer
var is_notify: bool = false
var player_inside := false

func _ready():
	var animator = $AnimatedSprite2D
	if animator:
		animator.play("default")
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(delta):
	if is_notify:
		return 
	#neu khong co den thi thong bao
	if player_inside and Input.is_action_just_pressed(ButtonKey.interact):
		if DoorID == 3:
			if !InventorySystem.CheckObjectInInventory(KeyData.Light) and Notification != null:
				is_notify = true
				Notification.show()
				await get_tree().create_timer(2.5).timeout
				Notification.hide()
				is_notify = false
				return
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
