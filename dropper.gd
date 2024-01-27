extends Node2D
class_name Dropper

@export var max_width = 400
@export var drop_time_min = 0.5
@export var drop_time_max = 1.5

@export var item : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize_drop_time()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func randomize_drop_time():
	$Timer.wait_time = randf_range(drop_time_min, drop_time_max)
	
func _on_timer_timeout() -> void:
	randomize_drop_time()
	var new_drop = item.instantiate()
	add_child(new_drop)
	new_drop.global_position.y = self.global_position.y
	new_drop.global_position.x = self.global_position.x + randi_range(0, max_width)

