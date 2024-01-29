extends Control

@onready var bird: Animal = $Bird

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_texture_button_button_up() -> void:
	get_tree().change_scene_to_file("res://game.tscn")
