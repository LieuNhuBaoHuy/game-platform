extends Node2D

@export_file("*.ogg") var bg_music : String

func _ready():
	MusicManager.play_music(bg_music)
