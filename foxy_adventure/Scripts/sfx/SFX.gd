extends Node


func play(path: String, volume_db: float = 0.0) -> void:
	if path == "":
		return

	if not ResourceLoader.exists(path):
		push_warning("Không tìm thấy file âm thanh: " + path)
		return

	var stream := ResourceLoader.load(path)

	if stream == null:
		push_warning("Không load được âm thanh: " + path)
		return

	var player := AudioStreamPlayer.new()
	add_child(player)

	player.stream = stream
	player.volume_db = volume_db
	player.finished.connect(player.queue_free)
	player.play()
