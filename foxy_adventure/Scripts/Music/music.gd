extends Node
@onready var player = $AudioStreamPlayer
func play_music(path: String, volume_db := -10.0):
	if player.stream != null:
		if player.stream.resource_path == path:
			return
	var music = load(path)
	if music == null:
		print("Không load được nhạc")
		return
	player.stream = music
	player.volume_db = volume_db
	player.play()
func stop_music():
	player.stop()
