extends Node

# Giữ nguyên hàm play() cũ
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


# --- NHẠC NỀN LOOP ---
var _bgm_player: AudioStreamPlayer = null

func play_loop(path: String, volume_db: float = 0.0) -> void:
	if path == "":
		return
	var stream := ResourceLoader.load(path)
	if stream == null:
		push_warning("SFX: Không load được nhạc nền: " + path)
		return
	# Nếu đang phát cùng bài thì không làm gì
	if _bgm_player != null and _bgm_player.stream == stream and _bgm_player.playing:
		return
	# Dừng bài cũ nếu có
	if _bgm_player != null:
		_bgm_player.stop()
		_bgm_player.queue_free()
	_bgm_player = AudioStreamPlayer.new()
	add_child(_bgm_player)
	_bgm_player.stream = stream
	_bgm_player.volume_db = volume_db
	# Bật loop
	if stream is AudioStreamMP3:
		stream.loop = true
	elif stream is AudioStreamOggVorbis:
		stream.loop = true
	elif stream is AudioStreamWAV:
		stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	_bgm_player.play()


func stop_loop() -> void:
	if _bgm_player != null:
		_bgm_player.stop()
		_bgm_player.queue_free()
		_bgm_player = null
