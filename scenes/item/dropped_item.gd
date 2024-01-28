extends RigidBody2D
class_name DroppedItem

var item : ItemType
@export var generic_dropped_scene : PackedScene

var flipped = false
func configure_for_item(item : ItemType):
	self.item = item
	
	var new_dropped_scene
	if item.dropped_scene:
		new_dropped_scene = item.dropped_scene.instantiate()
	else:
		new_dropped_scene = generic_dropped_scene.instantiate()
		new_dropped_scene.texture = item.icon
		new_dropped_scene.modulate = item.color
		new_dropped_scene.scale *= item.scale_factor
	
	if randf() < 0.5:
		flipped = true
		new_dropped_scene.scale = new_dropped_scene.scale * Vector2(-1, 1)
	add_child(new_dropped_scene)
