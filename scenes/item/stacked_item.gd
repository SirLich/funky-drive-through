extends Node2D
class_name StackedItem

@export var follow = Node
@export var stack_height = -50
@export var follow_time = 0.01
@onready var remote_transform_2d: RemoteTransform2D = $RemoteTransform2D

var tween : Tween

func _process(delta: float) -> void:
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", follow.global_position + Vector2(0, stack_height), follow_time)
