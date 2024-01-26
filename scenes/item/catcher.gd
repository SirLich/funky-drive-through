extends Node2D

@export var border_left = 750
@export var border_right = 1700
@export var stacked_item : PackedScene

@export var base : Node
@export var top : Node

func _ready() -> void:
	var last_stackable = base
	for i in range(3):
		var new_stackable = stacked_item.instantiate()
		new_stackable.follow = last_stackable
		add_child(new_stackable)
		last_stackable = new_stackable
		
	last_stackable.remote_transform_2d.remote_path = top.get_path()
	#top.reparent(last_stackable)
	
func _process(delta: float) -> void:
	base.global_position.x = clamp(get_global_mouse_position().x, border_left, border_right)
		
