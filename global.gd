extends Node

# TODO: This could be generated...
@export var all_items : Array[ItemType]
@export var top_bun : ItemType
@export var recipes : Array[Recipe]

var current_recipe = 0

func get_recipe():
	return recipes[current_recipe]

signal item_collected(item : ItemType)
signal bad_item_collected(item : ItemType, count : int)
signal good_item_collected(item : ItemType, count : int)
signal bun_collected()
signal tutorial_closed()

func _input(event: InputEvent) -> void:
	if event.is_action_released("exit"):
		get_tree().quit()
