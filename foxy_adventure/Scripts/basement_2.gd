extends Node2D

func _ready() -> void:
	SfxLoop.play_loop("res://Assets/audio/sfx/ambience/YTDown_YouTube_Sewer-Ambience-Without-Music-No-Jumpscar_Media_MPA54Hmtu1E_007_128k.mp3")

func _exit_tree() -> void:
	SfxLoop.stop_loop()
