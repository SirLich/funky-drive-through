extends Control

func _on_texture_button_button_up() -> void:
	get_tree().change_scene_to_file("res://game.tscn")
