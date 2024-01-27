extends Node2D

@export var border_left = 750
@export var border_right = 1700
@export var stacked_item : PackedScene

@export var base : Node
@export var top : Node

@export var starting_item : ItemType
	
var last_stacked
func add_new_item(new_item : ItemType):
	if last_stacked is StackedItem:
		last_stacked.remote_transform_2d.remote_path = NodePath()
	
	var new_stacked = stacked_item.instantiate()
	new_stacked.follow = last_stacked
	add_child(new_stacked)
	new_stacked.configure_for_item(new_item)
	last_stacked = new_stacked
	last_stacked.remote_transform_2d.remote_path = top.get_path()


func _ready() -> void:
	last_stacked = base
	for i in range(1):
		add_new_item(starting_item)
	
func _process(delta: float) -> void:
	base.global_position.x = clamp(get_global_mouse_position().x, border_left, border_right)

func _on_area_2d_body_entered(body: Node2D) -> void:
	Global.item_collected.emit(body.item)
	add_new_item(body.item)
	body.queue_free()
