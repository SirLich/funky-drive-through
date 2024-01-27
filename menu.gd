extends Control

@onready var bird: Bird = $Bird

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bird.become_neutral()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
