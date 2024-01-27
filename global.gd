extends Node

signal item_collected

func _input(event: InputEvent) -> void:
	if event.is_action_released("exit"):
		get_tree().quit()
