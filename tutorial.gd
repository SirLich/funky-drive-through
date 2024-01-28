extends Control

func _ready() -> void:
	get_tree().paused = true
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		get_tree().paused = false
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		self.queue_free()

