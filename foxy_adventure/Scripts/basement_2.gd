extends Node2D

func _ready() -> void:
	SFX_loop.play_loop("res://audio/sfx/ambience/YTDown_YouTube_Sewer-Ambience-Without-Music-No-Jumpscar_Media_MPA54Hmtu1E_007_128k.mp3")

func _exit_tree() -> void:
	SFX_loop.stop_loop()
