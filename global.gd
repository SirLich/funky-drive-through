extends Node

# TODO: This could be generated...
@export var all_items : Array[ItemType]

signal item_collected

func _input(event: InputEvent) -> void:
	if event.is_action_released("exit"):
		get_tree().quit()
