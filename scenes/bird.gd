extends Node2D
class_name Bird

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

func on_good_item_collected(item_type, count):
	become_happy()
	
func on_bad_item_collected(item_type : ItemType, count: int):
	become_angry()
		
func _ready() -> void:
	become_neutral()
	Global.bad_item_collected.connect(on_bad_item_collected)
	Global.good_item_collected.connect(on_good_item_collected)

func _process(delta: float) -> void:
	pass
