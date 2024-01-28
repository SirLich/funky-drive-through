extends Node2D
class_name StackedItem

@export var follow = Node
@export var stack_height = -25
@export var follow_time = 0.025

@onready var remote_transform_2d: RemoteTransform2D = $RemoteTransform2D
@onready var sprite: Sprite2D = $Sprite

@export var generic_dropped_scene : PackedScene

var tween : Tween

func configure_for_item(item : ItemType):
	var new_stacked_scene
	if item.stacked_scene:
		new_stacked_scene = item.stacked_scene.instantiate()
	else:
		new_stacked_scene = generic_dropped_scene.instantiate()
		new_stacked_scene.texture = item.icon
		new_stacked_scene.modulate = item.color
		new_stacked_scene.scale *= item.scale_factor
	add_child(new_stacked_scene)

func _process(delta: float) -> void:
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", follow.global_position + Vector2(0, stack_height), follow_time)
