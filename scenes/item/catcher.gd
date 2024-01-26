extends AnimatableBody2D

@export var border_left = 750
@export var border_right = 1700

func _process(delta: float) -> void:
	self.global_position.x = clamp(get_global_mouse_position().x, border_left, border_right)
		
