extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func become_angry():
	animation_player.play("angry")
	animation_player.animation_finished.connect(on_animation_finished)

func become_neutral():
	animation_player.play("neutral")

func become_happy():
	animation_player.play("happy")
	animation_player.animation_finished.connect(on_animation_finished)
	
func on_animation_finished():
	become_neutral()
	
func _ready() -> void:
	become_neutral()

func _process(delta: float) -> void:
	pass
