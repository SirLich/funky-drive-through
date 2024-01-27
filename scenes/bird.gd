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
	
func on_animation_finished(anim_name):
	become_neutral()

func on_item_collected():
	become_angry()
		
func _ready() -> void:
	become_neutral()
	Global.item_collected.connect(on_item_collected)

func _process(delta: float) -> void:
	pass
